import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/pages/projects/project_edit_page.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/searches/mixins/projects_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_projects.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_drawer_menu.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';

class ProjectsPage extends StatefulWidget {
  static const ROUTE_NAME = 'projects';

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage>
    with ProjectsPageAndSearchMixing {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ProjectsBloc _projectsBloc;

  @override
  void initState() {
    Constants.token = Preferences().token;

    _projectsBloc = context.read<BlocProvider>().projectsBloc;
    _projectsBloc.getProjects(false);
    super.initState();
  }

  @override
  void dispose() {
    _projectsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();

    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
            title: S.of(context).appBarTitleProjects,
            searchDelegate: SearchProjects(_projectsBloc)),
        body: _body(),
        floatingActionButton: FAB(
          routeName: ProjectEditPage.ROUTE_NAME,
        ),
        drawer: CustomDrawerMenu(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Widget _body() => CommonListOfModels(
        stream: _projectsBloc.projectStream,
        onRefresh: _onRefreshProjects,
        scaffoldKey: _scaffoldKey,
        buildItemList: (items, index) => buildItemList(context, items[index]),
      );

  Future<void> _onRefreshProjects() async =>
      await _projectsBloc.getProjects(true);
}
