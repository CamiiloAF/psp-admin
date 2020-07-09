import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psp_admin/src/models/projects_model.dart';
import 'package:psp_admin/src/pages/project_items/project_items_page.dart';
import 'package:psp_admin/src/pages/projects/project_edit_page.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin ProjectsPageAndSearchMixing {
  Widget buildItemList(BuildContext context, ProjectModel project,
      {Function closeSearch}) {
    return CustomListTile(
      title: project.name,
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.pushNamed(
              context, ProjectEditPage.ROUTE_NAME,
              arguments: project)),
      onTap: () {
        if (closeSearch != null) closeSearch();
        Navigator.pushNamed(context, ProjectItemsPage.ROUTE_NAME,
            arguments: project.id);
      },
      subtitle: project.description,
    );
  }
}
