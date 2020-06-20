import 'package:http/http.dart' as http;
import 'package:psp_admin/src/models/reusable_parts_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:tuple/tuple.dart';

class ReusablePartsRepository {
  Future<Tuple2<int, List<ReusablePartModel>>> getAllReusableParts(
      bool isRefresing, int programId) async {
    final networkBoundResource =
        _ReusablePartsNetworkBoundResource(RateLimiter(), programId);
    final response = await networkBoundResource.execute(isRefresing);

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      return response;
    }
  }
}

class _ReusablePartsNetworkBoundResource
    extends NetworkBoundResource<List<ReusablePartModel>> {
  final preferences = Preferences();

  final RateLimiter rateLimiter;
  final int programId;

  final tableName = Constants.REUSABLE_PARTS_TABLE_NAME;
  final _allReusableParts = 'allReusableParts';

  _ReusablePartsNetworkBoundResource(this.rateLimiter, this.programId);

  @override
  Future<http.Response> createCall() async {
    final url = '${Constants.baseUrl}/reusable-parts/by-program/$programId';

    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(List<ReusablePartModel> item) async {
    await DBProvider.db.deleteAll(tableName);

    if (item != null && item.isNotEmpty) {
      await DBProvider.db.insertList(item, tableName);
    }
  }

  @override
  bool shouldFetch(List<ReusablePartModel> data) =>
      data == null ||
      data.isEmpty ||
      rateLimiter.shouldFetch(_allReusableParts, Duration(minutes: 10));

  @override
  Future<List<ReusablePartModel>> loadFromDb() async =>
      _getReusablePartsFromJson(await DBProvider.db.getAllModelsByProgramId(
          Constants.REUSABLE_PARTS_TABLE_NAME, programId));

  List<ReusablePartModel> _getReusablePartsFromJson(
      List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res
            .map((reusabelPart) => ReusablePartModel.fromJson(reusabelPart))
            .toList()
        : [];
  }

  @override
  void onFetchFailed() {
    rateLimiter.reset(_allReusableParts);
  }

  @override
  List<ReusablePartModel> decodeData(List<dynamic> payload) =>
      ReusablePartsModel.fromJsonList(payload).reusableParts;
}
