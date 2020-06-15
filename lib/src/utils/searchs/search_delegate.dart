import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/projects_model.dart';

abstract class DataSearch extends SearchDelegate {
  String selection = '';

  List<ProjectModel> projects;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5))),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ));
  }

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
    return Container();
  }

  @protected
  Widget textNoResults(BuildContext context) =>
      Center(child: Text(S.of(context).thereIsNoInformation));
}
