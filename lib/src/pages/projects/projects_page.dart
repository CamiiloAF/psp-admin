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
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_drawer_menu.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

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

  Widget _body() {
    return StreamBuilder(
      stream: _projectsBloc.projectStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<ProjectModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final projects = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (projects.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshProjects(),
            child: ListView(
              children: [
                Center(
                  child: Text(S.of(context).thereIsNoInformation),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshProjects(),
          child: _buildListView(projects),
        );
      },
    );
  }

  ListView _buildListView(List<ProjectModel> projects) {
    return ListView.separated(
        itemCount: projects.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(projects, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<ProjectModel> projects, int i, BuildContext context) {
    return CustomListTile(
      title: projects[i].name,
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.pushNamed(context, 'editProject',
              arguments: projects[i])),
      onTap: () => Navigator.pushNamed(context, 'projectItems',
          arguments: projects[i].id),
      subtitle: projects[i].description,
    );
  }

  Future<void> _refreshProjects() async =>
      await _projectsBloc.getProjects(true);
}
