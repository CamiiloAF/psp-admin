import 'package:http/http.dart' as http;
import 'package:psp_admin/src/models/languages_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/insert_and_update_bound_resource.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:tuple/tuple.dart';

class LanguagesRepository {
  Future<Tuple2<int, List<LanguageModel>>> getAllLanguages(
      bool isRefresing) async {
    final networkBoundResource = _LanguagesNetworkBoundResource(RateLimiter());
    final response = await networkBoundResource.execute(isRefresing);

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      return response;
    }
  }

  Future<Tuple2<int, LanguageModel>> insertLanguage(
      LanguageModel languageModel) async {
    final url = '${Constants.baseUrl}/languages';

    return await _LanguagesInsertBoundResource()
        .executeInsert(languageModelToJson(languageModel), url);
  }

  Future<int> updateLanguage(LanguageModel languageModel) async {
    final url = '${Constants.baseUrl}/languages/${languageModel.id}';
    return await _LanguagesUpdateBoundResource()
        .executeUpdate(languageModelToJson(languageModel), languageModel, url);
  }
}

class _LanguagesNetworkBoundResource
    extends NetworkBoundResource<List<LanguageModel>> {
  final preferences = Preferences();

  final RateLimiter rateLimiter;

  final tableName = Constants.LANGUAGES_TABLE_NAME;
  final _allLanguages = 'allLanguages';

  _LanguagesNetworkBoundResource(this.rateLimiter);

  @override
  Future<http.Response> createCall() async {
    final url = '${Constants.baseUrl}/languages';
    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(List<LanguageModel> item) async {
    await DBProvider.db.deleteAll(tableName);

    if (item != null && item.isNotEmpty) {
      await DBProvider.db.insertList(item, tableName);
    }
  }

  @override
  bool shouldFetch(List<LanguageModel> data) =>
      data == null ||
      data.isEmpty ||
      rateLimiter.shouldFetch(_allLanguages, Duration(minutes: 10));

  @override
  Future<List<LanguageModel>> loadFromDb() async => _getLanguagesFromJson(
      await DBProvider.db.getAllModels(Constants.LANGUAGES_TABLE_NAME));

  List<LanguageModel> _getLanguagesFromJson(List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res
            .map((languageModel) => LanguageModel.fromJson(languageModel))
            .toList()
        : [];
  }

  @override
  void onFetchFailed() {}

  @override
  List<LanguageModel> decodeData(List<dynamic> payload) =>
      LanguagesModel.fromJsonList(payload).languages;
}

class _LanguagesInsertBoundResource
    extends InsertAndUpdateBoundResource<LanguageModel> {
  @override
  LanguageModel buildNewModel(payload) => LanguageModel.fromJson(payload);

  @override
  void doOperationInDb(LanguageModel model) async =>
      await DBProvider.db.insert(model, Constants.LANGUAGES_TABLE_NAME);
}

class _LanguagesUpdateBoundResource
    extends InsertAndUpdateBoundResource<LanguageModel> {
  @override
  LanguageModel buildNewModel(payload) => null;

  @override
  void doOperationInDb(LanguageModel model) async =>
      await DBProvider.db.update(model, Constants.LANGUAGES_TABLE_NAME);
}
