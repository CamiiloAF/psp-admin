import 'package:psp_admin/src/blocs/Validators.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/repositories/users_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class UsersBloc with Validators {
  final _usersProvider = UsersRepository();

  final _usersController = BehaviorSubject<Tuple2<int, List<UserModel>>>();

  Stream<Tuple2<int, List<UserModel>>> get usersStream =>
      _usersController.stream;

  Tuple2<int, List<UserModel>> get lastValueUsersController =>
      _usersController.value;

  void getUsers(bool isRefresing, int projectId, bool isByOrganization) async {
    final usersWithStatusCode = await _usersProvider.getAllUsers(
        isRefresing, projectId, isByOrganization);
    _usersController.sink.add(usersWithStatusCode);
  }

  Future<int> insertUser(UserModel user, int projecId) async {
    final result = await _usersProvider.insertUser(user, projecId);
    final statusCode = result.item1;

    if (statusCode == 201) {
      final tempUsers = lastValueUsersController.item2;
      tempUsers.add(result.item2);
      _usersController.sink.add(Tuple2(200, tempUsers));
    }
    return statusCode;
  }

  Future<int> updateUser(UserModel user) async {
    final statusCode = await _usersProvider.updateUser(user);

    if (statusCode == 204) {
      final tempUsers = lastValueUsersController.item2;
      final indexOfOldUser =
          tempUsers.indexWhere((element) => element.id == user.id);
      tempUsers[indexOfOldUser] = user;
      _usersController.sink.add(Tuple2(200, tempUsers));
    }
    return statusCode;
  }

  void dispose() {
    _usersController.sink.add(null);
  }
}
