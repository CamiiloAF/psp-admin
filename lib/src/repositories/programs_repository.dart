import 'package:http/http.dart' as http;
import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/insert_and_update_bound_resource.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:tuple/tuple.dart';

class ProgramsRepository {
  Future<Tuple2<int, List<ProgramModel>>> getProgramsByModuleId(
      bool isRefreshing, int moduleId) async {
    final networkBoundResource =
        _ProgramsNetworkBoundResource(RateLimiter(), '$moduleId');

    final response = await networkBoundResource.execute(isRefreshing);

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      return response;
    }
  }

  Future<Tuple2<int, List<Tuple2<int, String>>>>
      getAllProgramsByOrganization() async {
    final networkBoundResource =
        _ProgramsByOrganizationNetworkBoundResource(RateLimiter());

    final response = await networkBoundResource.execute(true);

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      return response;
    }
  }

  Future<Tuple2<int, ProgramModel>> insertProgram(ProgramModel program) async {
    final url = '${Constants.baseUrl}/programs';

    return await _ProgramsInsertBoundResource()
        .executeInsert(programModelToJson(program), url);
  }

  Future<int> updateProgram(ProgramModel program) async {
    final url = '${Constants.baseUrl}/programs/${program.id}';
    return await _ProgramsUpdateBoundResource()
        .executeUpdate(programModelToJson(program), program, url);
  }
}

class _ProgramsNetworkBoundResource
    extends NetworkBoundResource<List<ProgramModel>> {
  final RateLimiter rateLimiter;
  final String moduleId;

  final tableName = Constants.PROGRAMS_TABLE_NAME;
  final _allPrograms = 'allPrograms';

  _ProgramsNetworkBoundResource(this.rateLimiter, this.moduleId);

  @override
  Future<http.Response> createCall() async {
    final url = '${Constants.baseUrl}/programs/by-module/$moduleId';
    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(List<ProgramModel> item) async {
    await DBProvider.db.deleteAllByModuleId(moduleId, tableName);

    if (item != null && item.isNotEmpty) {
      await DBProvider.db.insertList(item, tableName);
    }
  }

  @override
  bool shouldFetch(List<ProgramModel> data) =>
      data == null ||
      data.isEmpty ||
      rateLimiter.shouldFetch(_allPrograms, Duration(minutes: 10));

  @override
  Future<List<ProgramModel>> loadFromLocalStorage() async => _getProgramsFromJson(
      await DBProvider.db.getAllProgramsByModuleId(moduleId));

  List<ProgramModel> _getProgramsFromJson(List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res.map((program) => ProgramModel.fromJson(program)).toList()
        : [];
  }

  @override
  void onFetchFailed() {
    rateLimiter.reset(_allPrograms);
  }

  @override
  List<ProgramModel> decodeData(List<dynamic> payload) =>
      ProgramsModel.fromJsonList(payload).programs;
}

class _ProgramsByOrganizationNetworkBoundResource
    extends NetworkBoundResource<List<Tuple2<int, String>>> {
  List<Tuple2<int, String>> callResult;

  final RateLimiter rateLimiter;
  final _allPrograms = 'allPrograms';

  _ProgramsByOrganizationNetworkBoundResource(this.rateLimiter);

  @override
  Future<http.Response> createCall() async {
    final url = '${Constants.baseUrl}/programs/by-organization';
    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(List<dynamic> item) async => callResult = item;

  @override
  bool shouldFetch(List<dynamic> data) =>
      rateLimiter.shouldFetch(_allPrograms, Duration(minutes: 10));

  @override
  Future<List<Tuple2<int, String>>> loadFromLocalStorage() async =>
      (callResult == null) ? null : callResult;

  @override
  void onFetchFailed() {}

  @override
  List<Tuple2<int, String>> decodeData(List<dynamic> payload) {
    final items = <Tuple2<int, String>>[];

    if (payload != null && payload.isNotEmpty) {
      payload.forEach((element) {
        items.add(Tuple2(element['id'], element['name']));
      });
    }

    return items;
  }
}

class _ProgramsInsertBoundResource
    extends InsertAndUpdateBoundResource<ProgramModel> {
  @override
  ProgramModel buildNewModel(payload) => ProgramModel.fromJson(payload);

  @override
  void doOperationInDb(ProgramModel model) async =>
      await DBProvider.db.insert(model, Constants.PROGRAMS_TABLE_NAME);
}

class _ProgramsUpdateBoundResource
    extends InsertAndUpdateBoundResource<ProgramModel> {
  @override
  ProgramModel buildNewModel(payload) => null;

  @override
  void doOperationInDb(ProgramModel model) async =>
      await DBProvider.db.update(model, Constants.PROGRAMS_TABLE_NAME);
}
