import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/blocs/provider.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/search_delegate.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/two_line_list_tile.dart';

class ProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projectsBloc = Provider.projectBloc(context);

    Constants.token = Preferences().token;
    projectsBloc.getProjects();

    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogLoading);

    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appBarTitleProjects),
          actions: appBarActions(context, projectsBloc),
        ),
        body: _body(projectsBloc, progressDialog));
  }

  List<Widget> appBarActions(BuildContext context, ProjectsBloc projectsBloc) {
    return [
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: DataSearch(projectsBloc));
          })
    ];
  }

  Widget _body(ProjectsBloc projectsBloc, ProgressDialog progressDialog) {
    return StreamBuilder(
      stream: projectsBloc.projectStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProjectModel>> snapshot) {
        if (!snapshot.hasData) {
          changeProgressDialogStatus(progressDialog, true);
          return Container(); 
        }

        final projects = snapshot.data;

        changeProgressDialogStatus(progressDialog, false);

        if (projects.isEmpty) {
          return Center(
            child: Text('No hay información'),
          );
        }

        return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, i) => TwoLineListTile(
                  title: projects[i].name,
                  onTap: () => {},
                  subtitle: projects[i].description,
                ));
      },
    );
  }

  void changeProgressDialogStatus(
      ProgressDialog progressDialog, bool show) async {
    // if (show)
    //   await progressDialog.show();
    // else
    //   await progressDialog.hide();
  }
}
