import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/blocs/provider.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/searchs/search_projects.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/two_line_list_tile.dart';
import 'package:tuple/tuple.dart';

class ProjectsPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final projectsBloc = Provider.projectBloc(context);

    Constants.token = Preferences().token;
    projectsBloc.getProjects(context);

    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogLoading);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(S.of(context).appBarTitleProjects),
        actions: appBarActions(context, projectsBloc),
      ),
      body: _body(projectsBloc, progressDialog),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'editProject');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> appBarActions(BuildContext context, ProjectsBloc projectsBloc) {
    return [
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
                context: context, delegate: ProjectsSearch(projectsBloc));
          })
    ];
  }

  Widget _body(ProjectsBloc projectsBloc, ProgressDialog progressDialog) {
    return StreamBuilder(
      stream: projectsBloc.projectStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<ProjectModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final projects = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey, statusCode);
        }

        if (projects.isEmpty) {
          return Center(
            child: Text(S.of(context).thereIsNoInformation),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshProjects(context, projectsBloc),
          child: _buildListView(projects),
        );
      },
    );
  }

  ListView _buildListView(List<ProjectModel> projects) {
    return ListView.separated(
        itemCount: projects.length,
        physics: AlwaysScrollableScrollPhysics(),
        //TODO Change before release if necessary
        // physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(projects, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<ProjectModel> projects, int i, BuildContext context) {
    return TwoLineListTile(
      title: projects[i].name,
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, 'editProject', arguments: projects[i]);
          }),
      onTap: () => {},
      subtitle: projects[i].description,
    );
  }

  Future<void> _refreshProjects(
      BuildContext context, ProjectsBloc projectsBloc) async {
    await projectsBloc.getProjects(context);
  }
}
