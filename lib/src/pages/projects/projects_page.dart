import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/searchs/search_projects.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_drawer_menu.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
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
    if (!isValidToken()) return NotAutorizedScreen();

    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
            title: S.of(context).appBarTitleProjects,
            searchDelegate: SearchProjects(_projectsBloc)),
        body: _body(),
        floatingActionButton: FAB(
          routeName: 'editProject',
        ),
        drawer: CustomDrawerMenu(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Widget _body() => CommonListOfModels(
        stream: _projectsBloc.projectStream,
        onRefresh: _onRefreshProjects,
        scaffoldState: _scaffoldKey.currentState,
        buildItemList: (items, index) => _buildItemList(items[index]),
      );

  Widget _buildItemList(ProjectModel project) {
    return CustomListTile(
      title: project.name,
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () =>
              Navigator.pushNamed(context, 'editProject', arguments: project)),
      onTap: () =>
          Navigator.pushNamed(context, 'projectItems', arguments: project.id),
      subtitle: project.description,
    );
  }

  Future<void> _onRefreshProjects() async =>
      await _projectsBloc.getProjects(true);
}
