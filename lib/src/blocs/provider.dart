import 'package:psp_admin/src/blocs/login_bloc.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';

class BlocProvider {
  final _loginBloc = LoginBloc();
  final _projectBloc = ProjectsBloc();

  LoginBloc get loginBloc => _loginBloc;
  ProjectsBloc get projectBloc => _projectBloc;
}
