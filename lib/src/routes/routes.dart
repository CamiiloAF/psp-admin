import 'package:flutter/cupertino.dart';
import 'package:psp_admin/src/pages/base_parts/base_parts_page.dart';
import 'package:psp_admin/src/pages/defect_logs/defect_log_detail_page.dart';
import 'package:psp_admin/src/pages/defect_logs/defect_logs_page.dart';
import 'package:psp_admin/src/pages/experiences/experiences_page.dart';
import 'package:psp_admin/src/pages/languages/languages_page.dart';
import 'package:psp_admin/src/pages/login/login_page.dart';
import 'package:psp_admin/src/pages/modules/module_edit_page.dart';
import 'package:psp_admin/src/pages/new_parts/new_part_detail_page.dart';
import 'package:psp_admin/src/pages/new_parts/new_parts_page.dart';
import 'package:psp_admin/src/pages/profile/profile_page.dart';
import 'package:psp_admin/src/pages/programs/program_create_page.dart';
import 'package:psp_admin/src/pages/programs/program_info_page.dart';
import 'package:psp_admin/src/pages/programs/program_items_page.dart';
import 'package:psp_admin/src/pages/programs/programs_page.dart';
import 'package:psp_admin/src/pages/project_items/project_items_page.dart';
import 'package:psp_admin/src/pages/projects/project_edit_page.dart';
import 'package:psp_admin/src/pages/projects/projects_page.dart';
import 'package:psp_admin/src/pages/reusable_parts/reusable_part_detail_page.dart';
import 'package:psp_admin/src/pages/reusable_parts/reusable_parts_page.dart';
import 'package:psp_admin/src/pages/base_parts/base_part_detail_page.dart';
import 'package:psp_admin/src/pages/settings/settings_page.dart';
import 'package:psp_admin/src/pages/test_reports/test_report_detail_page.dart';
import 'package:psp_admin/src/pages/test_reports/test_reports_page.dart';
import 'package:psp_admin/src/pages/time_logs/time_log_detail_page.dart';
import 'package:psp_admin/src/pages/time_logs/time_logs_page.dart';
import 'package:psp_admin/src/pages/users/users_edit_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() => <String, WidgetBuilder>{
      LoginPage.ROUTE_NAME: (BuildContext context) => LoginPage(),
      ProjectsPage.ROUTE_NAME: (BuildContext context) => ProjectsPage(),
      ProjectEditPage.ROUTE_NAME: (BuildContext context) => ProjectEditPage(),
      ModuleEditPage.ROUTE_NAME: (BuildContext context) => ModuleEditPage(),
      ProjectItemsPage.ROUTE_NAME: (BuildContext context) => ProjectItemsPage(),
      UserEditPage.ROUTE_NAME: (BuildContext context) => UserEditPage(),
      ExperiencesPage.ROUTE_NAME: (BuildContext context) => ExperiencesPage(),
      ProgramCreatePage.ROUTE_NAME: (BuildContext context) =>
          ProgramCreatePage(),
      ProgramsPage.ROUTE_NAME: (BuildContext context) => ProgramsPage(),
      ProgramInfoPage.ROUTE_NAME: (BuildContext context) => ProgramInfoPage(),
      ProgramItemsPage.ROUTE_NAME: (BuildContext context) => ProgramItemsPage(),
      BasePartsPage.ROUTE_NAME: (BuildContext context) => BasePartsPage(),
      BasePartDetailPage.ROUTE_NAME: (BuildContext context) =>
          BasePartDetailPage(),
      NewPartsPage.ROUTE_NAME: (BuildContext context) => NewPartsPage(),
      NewPartDetailPage.ROUTE_NAME: (BuildContext context) =>
          NewPartDetailPage(),
      ReusablePartsPage.ROUTE_NAME: (BuildContext context) =>
          ReusablePartsPage(),
      ReusablePartDetailPage.ROUTE_NAME: (BuildContext context) =>
          ReusablePartDetailPage(),
      DefectLogsPage.ROUTE_NAME: (BuildContext context) => DefectLogsPage(),
      DefectLogDetailPage.ROUTE_NAME: (BuildContext context) =>
          DefectLogDetailPage(),
      TimeLogsPage.ROUTE_NAME: (BuildContext context) => TimeLogsPage(),
      TimeLogDetailPage.ROUTE_NAME: (BuildContext context) =>
          TimeLogDetailPage(),
      TestReportsPage.ROUTE_NAME: (BuildContext context) => TestReportsPage(),
      TestReportDetailPage.ROUTE_NAME: (BuildContext context) =>
          TestReportDetailPage(),
      LanguagesPage.ROUTE_NAME: (BuildContext context) => LanguagesPage(),
      ProfilePage.ROUTE_NAME: (BuildContext context) => ProfilePage(),
      SettingsPage.ROUTE_NAME: (BuildContext context) => SettingsPage(),
    };
