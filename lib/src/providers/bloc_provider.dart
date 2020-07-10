import 'package:psp_admin/src/blocs/base_parts_bloc.dart';
import 'package:psp_admin/src/blocs/defect_logs_bloc.dart';
import 'package:psp_admin/src/blocs/experiences_bloc.dart';
import 'package:psp_admin/src/blocs/languages_bloc.dart';
import 'package:psp_admin/src/blocs/login_bloc.dart';
import 'package:psp_admin/src/blocs/modules_bloc.dart';
import 'package:psp_admin/src/blocs/new_parts_bloc.dart';
import 'package:psp_admin/src/blocs/programs_bloc.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/blocs/reusable_parts_bloc.dart';
import 'package:psp_admin/src/blocs/test_reports_bloc.dart';
import 'package:psp_admin/src/blocs/time_logs_bloc.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';

class BlocProvider {
  final _loginBloc = LoginBloc();
  final _projectsBloc = ProjectsBloc();
  final _modulesBloc = ModulesBloc();

  final _usersBloc = UsersBloc();
  final _experiencesBloc = ExperiencesBloc();

  final _programsBloc = ProgramsBloc();
  final _languagesBloc = LanguagesBloc();

  final _basePartsBloc = BasePartsBloc();
  final _newPartsBloc = NewPartsBloc();
  final _reusablePartsBloc = ReusablePartsBloc();

  final _defectLogsBloc = DefectLogsBloc();
  final _timeLogsBloc = TimeLogsBloc();

  final _testReportsBloc = TestReportsBloc();

  LoginBloc get loginBloc {
    _loginBloc.experiencesBloc = _experiencesBloc;
    return _loginBloc;
  }

  ProjectsBloc get projectsBloc => _projectsBloc;
  ModulesBloc get modulesBloc => _modulesBloc;

  UsersBloc get usersBloc => _usersBloc;
  ExperiencesBloc get experiencesBloc => _experiencesBloc;

  ProgramsBloc get programsBloc => _programsBloc;
  LanguagesBloc get languagesBloc => _languagesBloc;

  BasePartsBloc get basePartsBloc => _basePartsBloc;
  NewPartsBloc get newPartsBloc => _newPartsBloc;
  ReusablePartsBloc get reusablePartsBloc => _reusablePartsBloc;

  DefectLogsBloc get defectLogsBloc => _defectLogsBloc;
  TimeLogsBloc get timeLogsBloc => _timeLogsBloc;

  TestReportsBloc get testReportsBloc => _testReportsBloc;
}
