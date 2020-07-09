import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psp_admin/src/models/modules_model.dart';
import 'package:psp_admin/src/pages/modules/module_edit_page.dart';
import 'package:psp_admin/src/pages/programs/programs_page.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin ModulesPageAndSearchMixing {
  Widget buildItemList(BuildContext context, ModuleModel module, int projectId,
      {Function closeSearch}) {
    return CustomListTile(
      title: module.name,
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.pushNamed(
              context, ModuleEditPage.ROUTE_NAME,
              arguments: [module, projectId])),
      onTap: () {
        if (closeSearch != null) closeSearch();
        Navigator.pushNamed(context, ProgramsPage.ROUTE_NAME,
            arguments: module.id);
      },
      subtitle: module.description,
    );
  }
}
