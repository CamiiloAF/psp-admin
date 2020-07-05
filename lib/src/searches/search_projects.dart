import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/searches/mixins/projects_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_delegate.dart';

class SearchProjects extends DataSearch with ProjectsPageAndSearchMixing {
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
          return buildItemList(context, project,
              closeSearch: () => close(context, null));
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
