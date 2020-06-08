import 'package:flutter/material.dart';
import 'package:psp_admin/src/blocs/projects_bloc.dart';
import 'package:psp_admin/src/models/ProjectsModel.dart';

class DataSearch extends SearchDelegate {
  String selection = '';
  ProjectsBloc _projectsBloc;

  List<ProjectModel> projects;

  DataSearch(this._projectsBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
          height: 100.0,
          width: 100.0,
          color: Theme.of(context).primaryColor,
          child: Text(selection)),
    );
  }

  @protected
  Widget _textNoResults() => Center(child: Text('No hay resultados'));

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return _textNoResults();

    _projectsBloc.searchProject(query);
    
    return StreamBuilder(
        stream: _projectsBloc.projectStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ProjectModel>> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return Container(
                child: ListView(
              children: snapshot.data.map((project) {
                return ListTile(
                  title: Text(project.name),
                  subtitle: Text(
                    project.description,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    close(context, null);
                  },
                );
              }).toList(),
            ));
          }else
            return _textNoResults();
        });
  }
}
