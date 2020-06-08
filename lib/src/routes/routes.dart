import 'package:flutter/cupertino.dart';
import 'package:psp_admin/src/pages/login_page.dart';
import 'package:psp_admin/src/pages/projects_page.dart';

Map<String, WidgetBuilder>  getApplicationRoutes() => <String, WidgetBuilder>{
      'login': (BuildContext context) => LoginPage(),
      'projects': (BuildContext context) => ProjectsPage(),
    };
