import 'package:flutter/cupertino.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/utils/searchs/search_delegate.dart';
import 'package:psp_admin/src/widgets/two_line_list_tile.dart';

class ProjectsSearch extends DataSearch {
  final ProjectsBloc _projectsBloc;

  ProjectsSearch(this._projectsBloc);

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
          return TwoLineListTile(
            title: project.name,
            onTap: () => close(context, null),
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
