import 'dart:convert';

class UsersModel {
  List<UserModel> users = [];

  UsersModel();

  UsersModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final user = UserModel.fromJson(item);
      users.add(user);
    }
  }
}

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data, {bool isNewUser = false}) =>
    json.encode(data.toJson(isNewUser: isNewUser));

class UserModel {
  UserModel({
    this.id,
    this.organizationsId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.rol,
  });

  int id;
  int organizationsId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String rol;
  String password;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        organizationsId: json['organizations_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        phone: json['phone'],
        rol: json['rol'],
      );

  Map<String, dynamic> toJson({bool isNewUser = false}) => (isNewUser)
      ? {
          'id': id,
          'organizations_id': organizationsId,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
          'rol': rol,
          'password': password,
        }
      : {
          'id': id,
          'organizations_id': organizationsId,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
          'rol': rol,
        };
}
