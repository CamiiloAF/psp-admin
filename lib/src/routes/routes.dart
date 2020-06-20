import 'package:flutter/cupertino.dart';
import 'package:psp_admin/src/pages/base_parts/base_parts_page.dart';
import 'package:psp_admin/src/pages/defect_logs/defect_logs_page.dart';
import 'package:psp_admin/src/pages/login_page.dart';
import 'package:psp_admin/src/pages/modules/module_edit_page.dart';
import 'package:psp_admin/src/pages/new_parts/new_parts_page.dart';
import 'package:psp_admin/src/pages/programs/program_create_page.dart';
import 'package:psp_admin/src/pages/programs/program_items_page.dart';
import 'package:psp_admin/src/pages/project_items/project_items_page.dart';
import 'package:psp_admin/src/pages/projects/project_edit_page.dart';
import 'package:psp_admin/src/pages/projects/projects_page.dart';
import 'package:psp_admin/src/pages/reusable_parts/reusable_parts_page.dart';
import 'package:psp_admin/src/pages/time_logs/time_logs_page.dart';
import 'package:psp_admin/src/pages/users/users_edit_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() => <String, WidgetBuilder>{
      'login': (BuildContext context) => LoginPage(),
      'projects': (BuildContext context) => ProjectsPage(),
      'editProject': (BuildContext context) => ProjectEditPage(),
      'editModule': (BuildContext context) => ModuleEditPage(),
      'projectItems': (BuildContext context) => ProjectItemsPage(),
      'editUser': (BuildContext context) => UserEditPage(),
      'createProgram': (BuildContext context) => ProgramCreatePage(),
      'programItems': (BuildContext context) => ProgramItemsPage(),
      'baseParts': (BuildContext context) => BasePartsPage(),
      'newParts': (BuildContext context) => NewPartsPage(),
      'reusableParts': (BuildContext context) => ReusablePartsPage(),
      'defectLogs': (BuildContext context) => DefectLogsPage(),
      'timeLogs': (BuildContext context) => TimeLogsPage(),
    };
