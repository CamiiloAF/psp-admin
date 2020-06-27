import 'package:psp_admin/src/blocs/Validators.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/repositories/users_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class UsersBloc with Validators {
  final _usersProvider = UsersRepository();

  final _usersByProjectIdController =
      BehaviorSubject<Tuple2<int, List<UserModel>>>();

  final _usersByOrganizationIdController =
      BehaviorSubject<Tuple2<int, List<UserModel>>>();

  Stream<Tuple2<int, List<UserModel>>> get usersByProjectIdStream =>
      _usersByProjectIdController.stream;

  Tuple2<int, List<UserModel>> get lastValueUsersByProjectController =>
      _usersByProjectIdController.value;

  Stream<Tuple2<int, List<UserModel>>> get usersByOrganizationStream =>
      _usersByOrganizationIdController.stream;

  Tuple2<int, List<UserModel>> get lastValueUsersByOrganizationController =>
      _usersByOrganizationIdController.value;

  void getUsers(bool isRefreshing, int projectId, bool isByOrganization) async {
    final usersWithStatusCode = await _usersProvider.getAllUsers(
        isRefreshing, projectId, isByOrganization);
    if (isByOrganization) {
      _usersByOrganizationIdController.sink.add(usersWithStatusCode);
    } else {
      _usersByProjectIdController.sink.add(usersWithStatusCode);
    }
  }

  Future<int> insertUser(UserModel user, int projecId) async {
    final result = await _usersProvider.insertUser(user, projecId);
    final statusCode = result.item1;

    if (statusCode == 201) {
      _addUserIntoStream(result.item2, true);
    }
    return statusCode;
  }

  Future<int> updateUser(UserModel user) async {
    final statusCode = await _usersProvider.updateUser(user);

    if (statusCode == 204) {
      final tempUsersByOrganizationId =
          lastValueUsersByOrganizationController.item2;

      final indexOfOldUserByOrganizationId = tempUsersByOrganizationId
          .indexWhere((element) => element.id == user.id);

      final tempUsersByProjectId = lastValueUsersByProjectController.item2;

      final indexOfOldUserByProjectId =
          tempUsersByProjectId.indexWhere((element) => element.id == user.id);

      tempUsersByOrganizationId[indexOfOldUserByOrganizationId] = user;

      if (indexOfOldUserByProjectId != -1) {
        tempUsersByProjectId[indexOfOldUserByOrganizationId] = user;
      }

      _usersByOrganizationIdController.sink
          .add(Tuple2(200, tempUsersByOrganizationId));
      _usersByProjectIdController.sink.add(Tuple2(200, tempUsersByProjectId));
    }
    return statusCode;
  }

  Future<int> addUserToProject(int projectId, UserModel user) async {
    final statusCode =
        await _usersProvider.modifyUserProject(projectId, user.id, true);

    if (statusCode == 201) {
      _addUserIntoStream(user, false);
    }
    return statusCode;
  }

  Future<int> removeUserFromProject(int projectId, UserModel user) async {
    final statusCode =
        await _usersProvider.modifyUserProject(projectId, user.id, false);

    if (statusCode == 201) {
      final tempUsers = lastValueUsersByProjectController.item2;
      tempUsers.remove(user);
      _usersByProjectIdController.sink.add(Tuple2(200, tempUsers));
    }
    return statusCode;
  }

  void _addUserIntoStream(UserModel model, bool isByOrganizationId) {
    final tempUsers = (isByOrganizationId)
        ? lastValueUsersByOrganizationController.item2
        : lastValueUsersByProjectController.item2;

    tempUsers.add(model);
    if (isByOrganizationId) {
      _usersByOrganizationIdController.sink.add(Tuple2(200, tempUsers));
    } else {
      _usersByProjectIdController.sink.add(Tuple2(200, tempUsers));
    }
  }

  void dispose() {
    _usersByProjectIdController.sink.add(null);
  }
}
