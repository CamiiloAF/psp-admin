import 'package:http/http.dart' as http;
import 'package:psp_admin/src/models/defect_logs_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:tuple/tuple.dart';

class DefectLogsRepository {
  Future<Tuple2<int, List<DefectLogModel>>> getAllDefectLogs(
      bool isRefreshing, int programId) async {
    final networkBoundResource =
        _DefectLogsNetworkBoundResource(RateLimiter(), programId);
    final response = await networkBoundResource.execute(isRefreshing);

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      return response;
    }
  }
}

class _DefectLogsNetworkBoundResource
    extends NetworkBoundResource<List<DefectLogModel>> {
  final RateLimiter rateLimiter;
  final int programId;

  final tableName = Constants.DEFECT_LOGS_TABLE_NAME;
  final _allDefectLogs = 'allDefectLogs';

  _DefectLogsNetworkBoundResource(this.rateLimiter, this.programId);

  @override
  Future<http.Response> createCall() async {
    final url = '${Constants.baseUrl}/defect-logs/by-program/$programId';

    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(List<DefectLogModel> item) async {
    await DBProvider.db.deleteAll(tableName);

    if (item != null && item.isNotEmpty) {
      await DBProvider.db.insertList(item, tableName);
    }
  }

  @override
  bool shouldFetch(List<DefectLogModel> data) =>
      data == null ||
      data.isEmpty ||
      rateLimiter.shouldFetch(_allDefectLogs, Duration(minutes: 10));

  @override
  Future<List<DefectLogModel>> loadFromLocalStorage() async =>
      _getDefectLogsFromJson(await DBProvider.db.getAllModelsByProgramId(
          Constants.DEFECT_LOGS_TABLE_NAME, programId));

  List<DefectLogModel> _getDefectLogsFromJson(List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res.map((defectLog) => DefectLogModel.fromJson(defectLog)).toList()
        : [];
  }

  @override
  void onFetchFailed() {
    rateLimiter.reset(_allDefectLogs);
  }

  @override
  List<DefectLogModel> decodeData(List<dynamic> payload) =>
      DefectLogsModel.fromJsonList(payload).defectLogs;
}
