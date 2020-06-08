import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/blocs/provider.dart';
import 'package:psp_admin/src/utils/search_delegate.dart';
import 'package:psp_admin/src/utils/utils.dart';

class ProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projectsBloc = Provider.projectBloc(context);

    projectsBloc.getProjects();

    final progressDialog = getProgressDialog(context, S.of(context).progressDialogLoading);

    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appBarTitleProjects),
          actions: appBarActions(context, projectsBloc),
        ),
        body: StreamBuilder(
          stream: projectsBloc.loadingStream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot)  {
            if (snapshot.hasData && snapshot.data) {
              // progressDialog.show();
              return Container();
            } else {
              // progressDialog.hide();
              return Container(
                child: Center(
                  child: Text('Proyectos'),
                ),
              );
            }
          },
        ));
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
}
