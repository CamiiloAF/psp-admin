import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/pages/modules/modules_page.dart';
import 'package:psp_admin/src/utils/searchs/search_delegate.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

class SearchProjects extends DataSearch {
  final ProjectsBloc _projectsBloc;

  SearchProjects(this._projectsBloc);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    final projects = _projectsBloc?.lastValueProjectsController?.item2 ?? [];
    if (projects.isNotEmpty && projects != null) {
      return Container(
          child: ListView(
        children: projects
            .where((project) => _areItemContainQuery(project, query))
            .map((project) {
          return CustomListTile(
            title: project.name,
            onTap: () {
              close(context, null);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: 'modules'),
                      builder: (_) => ModulesPage(projectId: '${project.id}')));
            },
            subtitle: project.description,
          );
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(ProjectModel project, String query) {
    return project.name.toLowerCase().contains(query.toLowerCase()) ||
            project.description.toLowerCase().contains(query.toLowerCase())
        ? true
        : false;
  }
}
