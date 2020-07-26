import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';
import 'package:psp_admin/src/models/summary/program_summary_model.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:tuple/tuple.dart';

class ProgramSummaryRepository {
  Future<Tuple2<int, List<ProgramSummaryModel>>> getProgramSummary(
      int programId) async {
    final networkBoundResource = _ProgramSummaryNetworkBoundResource(programId);
    final response = await networkBoundResource.execute(true);

    return (response.item2 == null) ? Tuple2(response.item1, []) : response;
  }
}

class _ProgramSummaryNetworkBoundResource
    extends NetworkBoundResource<List<ProgramSummaryModel>> {
  final int programId;

  List<ProgramSummaryModel> callResult;

  _ProgramSummaryNetworkBoundResource(this.programId);

  @override
  Future<Response> createCall() async {
    final url = '${Constants.baseUrl}/pps/by-program/$programId';
    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  List<ProgramSummaryModel> decodeData(List<dynamic> payload) =>
      [ProgramSummaryModel.fromJson(payload[0])];

  @override
  Future<List<ProgramSummaryModel>> loadFromLocalStorage() async =>
      (callResult == null) ? null : callResult;

  @override
  void onFetchFailed() {}

  @override
  Future saveCallResult(List<ProgramSummaryModel> item) async =>
      callResult = item;

  @override
  bool shouldFetch(List<ProgramSummaryModel> data) => true;
}
