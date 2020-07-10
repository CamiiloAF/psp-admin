import 'package:http/http.dart' as http;
import 'package:psp_admin/src/models/experience_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:psp_admin/src/utils/network_bound_resources/insert_and_update_bound_resource.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:tuple/tuple.dart';

class ExperienceRepository {
  Future<Tuple2<int, ExperienceModel>> getExperience(
      bool isRefreshing, int userId) async {
    final networkBoundResource =
        _ExperienceNetworkBoundResource(RateLimiter(), userId);

    final response = await networkBoundResource.execute(true);

    return (response.item2 == null) ? Tuple2(response.item1, null) : response;
  }

  Future<Tuple2<int, ExperienceModel>> insertExperience(
      ExperienceModel experience) async {
    final url = '${Constants.baseUrl}/experiences';

    return await _ExperienceInsertBoundResource()
        .executeInsert(experienceModelToJson(experience), url);
  }

  Future<int> updateExperience(ExperienceModel experience) async {
    final url = '${Constants.baseUrl}/experiences/${experience.id}';
    return await _ExperienceUpdateBoundResource()
        .executeUpdate(experienceModelToJson(experience), experience, url);
  }
}

class _ExperienceNetworkBoundResource
    extends NetworkBoundResource<ExperienceModel> {
  final RateLimiter rateLimiter;
  final int userId;

  final tableName = Constants.EXPERIENCES_TABLE_NAME;
  final _allExperiences = 'experiences';

  _ExperienceNetworkBoundResource(this.rateLimiter, this.userId);

  @override
  Future<http.Response> createCall() async {
    final url = '${Constants.baseUrl}/experiences/by-user/${userId}';

    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(ExperienceModel item) async {
    await DBProvider.db.deleteAll(tableName);

    if (item != null) {
      await DBProvider.db.insert(item, tableName);
    }
  }

  @override
  bool shouldFetch(ExperienceModel data) =>
      data == null ||
      rateLimiter.shouldFetch(_allExperiences, Duration(minutes: 10));

  @override
  Future<ExperienceModel> loadFromDb() async {
    // Es una lista con un sólo elemento o en su defecto con ninguno
    final experiences =
        await DBProvider.db.getAllModels(Constants.EXPERIENCES_TABLE_NAME);

    return (!isNullOrEmpty(experiences))
        ? _getExperienceFromJson(experiences[0])
        : null;
  }

  ExperienceModel _getExperienceFromJson(Map<String, dynamic> res) =>
      res.isNotEmpty ? ExperienceModel.fromJson(res) : null;

  @override
  void onFetchFailed() => rateLimiter.reset(_allExperiences);

  @override
  ExperienceModel decodeData(List<dynamic> payload) =>
      (!isNullOrEmpty(payload)) ? ExperienceModel.fromJson(payload[0]) : null;
}

class _ExperienceInsertBoundResource
    extends InsertAndUpdateBoundResource<ExperienceModel> {
  @override
  ExperienceModel buildNewModel(payload) => ExperienceModel.fromJson(payload);

  @override
  void doOperationInDb(ExperienceModel model) async =>
      await DBProvider.db.insert(model, Constants.EXPERIENCES_TABLE_NAME);
}

class _ExperienceUpdateBoundResource
    extends InsertAndUpdateBoundResource<ExperienceModel> {
  @override
  ExperienceModel buildNewModel(payload) => null;

  @override
  void doOperationInDb(ExperienceModel model) async =>
      await DBProvider.db.update(model, Constants.EXPERIENCES_TABLE_NAME);
}
