import 'package:http/http.dart' as http;
import 'package:psp_admin/src/models/modules_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/insert_and_update_bound_resource.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:tuple/tuple.dart';

class ModulesRepository {
  String lastProjectId;

  Future<Tuple2<int, List<ModuleModel>>> getAllModules(
      bool isRefresing, String projectId) async {
    final networkBoundResource =
        _ModulesNetworkBoundResource(RateLimiter(), projectId, lastProjectId);
    final response = await networkBoundResource.execute(isRefresing);

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      lastProjectId = projectId;
      return response;
    }
  }

  Future<Tuple2<int, ModuleModel>> insertModule(ModuleModel module) async {
    final url = '${Constants.baseUrl}/modules';

    return await _ModulesInsertBoundResource()
        .executeInsert(moduleModelToJson(module), url);
  }

  Future<int> updateModule(ModuleModel module) async {
    final url = '${Constants.baseUrl}/modules/${module.id}';
    return await _ModulesUpdateBoundResource()
        .executeUpdate(moduleModelToJson(module), module, url);
  }
}

class _ModulesNetworkBoundResource
    extends NetworkBoundResource<List<ModuleModel>> {
  final RateLimiter rateLimiter;
  final String projectId;
  final String lastProjectId;

  final tableName = Constants.MODULES_TABLE_NAME;
  final _allModules = 'allModules';

  _ModulesNetworkBoundResource(
      this.rateLimiter, this.projectId, this.lastProjectId);

  @override
  Future<http.Response> createCall() async {
    final url = '${Constants.baseUrl}/modules/by-project/$projectId';

    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(List<ModuleModel> item) async {
    await DBProvider.db.deleteAllByProjectId(projectId, tableName);

    if (item != null && item.isNotEmpty) {
      await DBProvider.db.insertList(item, tableName);
    }
  }

  @override
  bool shouldFetch(List<ModuleModel> data) =>
      data == null ||
      data.isEmpty ||
      projectId != lastProjectId ||
      rateLimiter.shouldFetch(_allModules, Duration(minutes: 10));

  @override
  Future<List<ModuleModel>> loadFromDb() async => _getModulesFromJson(
      await DBProvider.db.getAllByProjectId(projectId, tableName));

  List<ModuleModel> _getModulesFromJson(List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res.map((module) => ModuleModel.fromJson(module)).toList()
        : [];
  }

  @override
  void onFetchFailed() {
    rateLimiter.reset(_allModules);
  }

  @override
  List<ModuleModel> decodeData(List<dynamic> payload) =>
      ModulesModel.fromJsonList(payload).modules;
}

class _ModulesInsertBoundResource
    extends InsertAndUpdateBoundResource<ModuleModel> {
  @override
  ModuleModel buildNewModel(payload) => ModuleModel.fromJson(payload);

  @override
  void doOperationInDb(ModuleModel model) async =>
      await DBProvider.db.insert(model, Constants.MODULES_TABLE_NAME);
}

class _ModulesUpdateBoundResource
    extends InsertAndUpdateBoundResource<ModuleModel> {
  @override
  ModuleModel buildNewModel(payload) => null;

  @override
  void doOperationInDb(ModuleModel model) async =>
      await DBProvider.db.update(model, Constants.MODULES_TABLE_NAME);
}
