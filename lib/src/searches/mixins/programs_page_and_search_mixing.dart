import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/pages/programs/program_items_page.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin ProgramsPageAndSearchMixing {
  Widget buildItemList(BuildContext context, ProgramModel program, int moduleId,
      {Function closeSearch}) {
    return CustomListTile(
      title: program.name,
      isEnable: program.totalLines != null,
      trailing: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            Navigator.pushNamed(context, '', arguments: [program, moduleId]);
          }),
      onTap: () {
        if (closeSearch != null) closeSearch();
        Navigator.pushNamed(context, ProgramItemsPage.ROUTE_NAME,
            arguments: program);
      },
      subtitle: program.description,
    );
  }
}
