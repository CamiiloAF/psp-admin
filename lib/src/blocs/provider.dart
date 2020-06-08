import 'package:flutter/material.dart';
import 'package:psp_admin/src/blocs/login_bloc.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';

class Provider extends InheritedWidget {
  final _loginBloc = LoginBloc();
  final _projectBloc = ProjectsBloc();

  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    if (_instance == null)
      _instance = new Provider._internal(key: key, child: child);

    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  static LoginBloc loginBloc(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>())._loginBloc;

  static ProjectsBloc projectBloc(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>())._projectBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
