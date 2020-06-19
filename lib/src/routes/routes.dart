import 'package:flutter/cupertino.dart';
import 'package:psp_admin/src/pages/login_page.dart';
import 'package:psp_admin/src/pages/modules/module_edit_page.dart';
import 'package:psp_admin/src/pages/programs/program_create_page.dart';
import 'package:psp_admin/src/pages/project_items/project_items_page.dart';
import 'package:psp_admin/src/pages/projects/project_edit_page.dart';
import 'package:psp_admin/src/pages/projects/projects_page.dart';
import 'package:psp_admin/src/pages/users/users_edit_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() => <String, WidgetBuilder>{
      'login': (BuildContext context) => LoginPage(),
      'projects': (BuildContext context) => ProjectsPage(),
      'editProject': (BuildContext context) => ProjectEditPage(),
      'editModule': (BuildContext context) => ModuleEditPage(),
      'projectItems': (BuildContext context) => ProjectItemsPage(),
      'editUser': (BuildContext context) => UserEditPage(),
      'createProgram': (BuildContext context) => ProgramCreatePage(),
    };
