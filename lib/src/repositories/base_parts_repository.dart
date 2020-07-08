import 'package:http/http.dart' as http;
import 'package:psp_admin/src/models/base_parts_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:tuple/tuple.dart';

class BasePartsRepository {
  Future<Tuple2<int, List<BasePartModel>>> getAllBaseParts(
      bool isRefreshing, int programId) async {
    final networkBoundResource =
        _BasePartsNetworkBoundResource(RateLimiter(), programId);
    final response = await networkBoundResource.execute(isRefreshing);

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      return response;
    }
  }
}

class _BasePartsNetworkBoundResource
    extends NetworkBoundResource<List<BasePartModel>> {
  final RateLimiter rateLimiter;
  final int programId;

  final tableName = Constants.BASE_PARTS_TABLE_NAME;
  final _allBaseParts = 'allBaseParts';

  _BasePartsNetworkBoundResource(this.rateLimiter, this.programId);

  @override
  Future<http.Response> createCall() async {
    final url = '${Constants.baseUrl}/base-parts/by-program/$programId';

    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(List<BasePartModel> item) async {
    await DBProvider.db.deleteAll(tableName);

    if (item != null && item.isNotEmpty) {
      await DBProvider.db.insertList(item, tableName);
    }
  }

  @override
  bool shouldFetch(List<BasePartModel> data) =>
      data == null ||
      data.isEmpty ||
      rateLimiter.shouldFetch(_allBaseParts, Duration(minutes: 10));

  @override
  Future<List<BasePartModel>> loadFromDb() async =>
      _getBasePartsFromJson(await DBProvider.db
          .getAllModelsByProgramId(Constants.BASE_PARTS_TABLE_NAME, programId));

  List<BasePartModel> _getBasePartsFromJson(List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res.map((basePart) => BasePartModel.fromJson(basePart)).toList()
        : [];
  }

  @override
  void onFetchFailed() {
    rateLimiter.reset(_allBaseParts);
  }

  @override
  List<BasePartModel> decodeData(List<dynamic> payload) =>
      BasePartsModel.fromJsonList(payload).baseParts;
}
