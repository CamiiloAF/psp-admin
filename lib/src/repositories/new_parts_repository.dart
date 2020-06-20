import 'package:http/http.dart' as http;
import 'package:psp_admin/src/models/new_parts_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:tuple/tuple.dart';

class NewPartsRepository {
  Future<Tuple2<int, List<NewPartModel>>> getAllNewParts(
      bool isRefresing, int programId) async {
    final networkBoundResource =
        _NewPartsNetworkBoundResource(RateLimiter(), programId);
    final response = await networkBoundResource.execute(isRefresing);

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      return response;
    }
  }
}

class _NewPartsNetworkBoundResource
    extends NetworkBoundResource<List<NewPartModel>> {
  final preferences = Preferences();

  final RateLimiter rateLimiter;
  final int programId;

  final tableName = Constants.NEW_PARTS_TABLE_NAME;
  final _allNewParts = 'allNewParts';

  _NewPartsNetworkBoundResource(this.rateLimiter, this.programId);

  @override
  Future<http.Response> createCall() async {
    final url = '${Constants.baseUrl}/new-parts/by-program/$programId';

    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(List<NewPartModel> item) async {
    await DBProvider.db.deleteAll(tableName);

    if (item != null && item.isNotEmpty) {
      await DBProvider.db.insertList(item, tableName);
    }
  }

  @override
  bool shouldFetch(List<NewPartModel> data) =>
      data == null ||
      data.isEmpty ||
      rateLimiter.shouldFetch(_allNewParts, Duration(minutes: 10));

  @override
  Future<List<NewPartModel>> loadFromDb() async =>
      _getNewPartsFromJson(await DBProvider.db
          .getAllModelsByProgramId(Constants.NEW_PARTS_TABLE_NAME, programId));

  List<NewPartModel> _getNewPartsFromJson(List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res.map((newPart) => NewPartModel.fromJson(newPart)).toList()
        : [];
  }

  @override
  void onFetchFailed() {
    rateLimiter.reset(_allNewParts);
  }

  @override
  List<NewPartModel> decodeData(List<dynamic> payload) =>
      NewPartsModel.fromJsonList(payload).newParts;
}
