import 'package:psp_admin/src/blocs/login_bloc.dart';
import 'package:psp_admin/src/blocs/modules_bloc.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';

class BlocProvider {
  final _loginBloc = LoginBloc();
  final _projectsBloc = ProjectsBloc();
  final _modulesBloc = ModulesBloc();
  final _usersBloc = UsersBloc();

  LoginBloc get loginBloc => _loginBloc;
  ProjectsBloc get projectsBloc => _projectsBloc;
  ModulesBloc get modulesBloc => _modulesBloc;
  UsersBloc get usersBloc => _usersBloc;
}
