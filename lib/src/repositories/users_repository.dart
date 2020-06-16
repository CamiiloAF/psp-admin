import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/network_bound_resources/insert_and_update_bound_resource.dart';
import 'package:psp_admin/src/utils/network_bound_resources/network_bound_resource.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';
import 'package:tuple/tuple.dart';

class UsersRepository {
  Future<Tuple2<int, List<UserModel>>> getAllUsers(
      bool isRefresing, int projectId, bool isByOrganizationId) async {
    final networkBoundResource = _UsersNetworkBoundResource(
        RateLimiter(), projectId, isByOrganizationId);

    final response = await networkBoundResource.execute(isRefresing);

    if (response.item2 == null) {
      return Tuple2(response.item1, []);
    } else {
      return response;
    }
  }

  Future<Tuple2<int, UserModel>> insertUser(
      UserModel user, int projectId) async {
    final url = '${Constants.baseUrl}/users';

    return await _UsersInsertBoundResource(projectId)
        .executeInsert(userModelToJson(user), url);
  }

  Future<int> updateUser(UserModel user) async {
    final url = '${Constants.baseUrl}/users/${user.id}';
    return await _UsersUpdateBoundResource()
        .executeUpdate(userModelToJson(user), user, url);
  }
}

class _UsersNetworkBoundResource extends NetworkBoundResource<List<UserModel>> {
  final preferences = Preferences();

  final RateLimiter rateLimiter;
  final int _projectId;
  final bool _isByOrganizationId;

  final tableName = Constants.USERS_TABLE_NAME;
  final _allUsers = 'allUsers';

  _UsersNetworkBoundResource(
      this.rateLimiter, this._projectId, this._isByOrganizationId);

  @override
  Future<http.Response> createCall() async {
    var url = '${Constants.baseUrl}/users';

    if (!_isByOrganizationId) {
      url = '$url/by-project/$_projectId';
    }

    return await http.get(url, headers: Constants.getHeaders());
  }

  @override
  Future saveCallResult(List<UserModel> item) async {
    if (!_isByOrganizationId) {
      await DBProvider.db.deleteAllUsers();
    }
    if (item != null && item.isNotEmpty) {
      await DBProvider.db.insertUsers(item, _projectId);
    }
  }

  @override
  bool shouldFetch(List<UserModel> data) =>
      data == null ||
      data.isEmpty ||
      rateLimiter.shouldFetch(_allUsers, Duration(minutes: 10));

  @override
  Future<List<UserModel>> loadFromDb() async =>
      _getUsersFromJson((_isByOrganizationId)
          ? await DBProvider.db.getAllByOrganizationId(
              json.decode(preferences.curentUser)['organizations_id'],
              tableName)
          : await DBProvider.db.getAllUsertByProjectId(_projectId));

  List<UserModel> _getUsersFromJson(List<Map<String, dynamic>> res) {
    return res.isNotEmpty
        ? res.map((user) => UserModel.fromJson(user)).toList()
        : [];
  }

  @override
  void onFetchFailed() {
    rateLimiter.reset(_allUsers);
  }

  @override
  List<UserModel> decodeData(List<dynamic> payload) =>
      UsersModel.fromJsonList(payload).users;
}

class _UsersInsertBoundResource
    extends InsertAndUpdateBoundResource<UserModel> {
  final int projectId;

  _UsersInsertBoundResource(this.projectId);

  @override
  UserModel buildNewModel(payload) => UserModel.fromJson(payload);

  @override
  void doOperationInDb(UserModel model) async =>
      await DBProvider.db.insertUser(model, projectId);
}

class _UsersUpdateBoundResource
    extends InsertAndUpdateBoundResource<UserModel> {
  @override
  UserModel buildNewModel(payload) => null;

  @override
  void doOperationInDb(UserModel model) async =>
      await DBProvider.db.update(model, Constants.USERS_TABLE_NAME);
}
