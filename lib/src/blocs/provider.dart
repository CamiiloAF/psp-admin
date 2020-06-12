import 'package:flutter/material.dart';
import 'package:psp_admin/src/blocs/login_bloc.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';

class Provider extends InheritedWidget {
  final _loginBloc = LoginBloc();
  final _projectBloc = ProjectsBloc();

  final _rateLimiter = RateLimiter();

  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    _instance ??= Provider._internal(key: key, child: child);

    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  static LoginBloc loginBloc(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>())._loginBloc;

  static ProjectsBloc projectBloc(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>())._projectBloc;

  static RateLimiter rateLimiter(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>())._rateLimiter;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
