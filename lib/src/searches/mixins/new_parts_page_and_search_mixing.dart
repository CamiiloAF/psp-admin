import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/new_parts_model.dart';
import 'package:psp_admin/src/pages/new_parts/new_part_detail_page.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin NewPartsPageAndSearchMixing {
  Widget buildItemList(BuildContext context, NewPartModel newPart,
      {Function closeSearch}) {
    return CustomListTile(
      title: newPart.name,
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        if (closeSearch != null) closeSearch;
        Navigator.pushNamed(context, NewPartDetailPage.ROUTE_NAME,
            arguments: newPart);
      },
      subtitle: '${S.of(context).labelPlannedLines} ${newPart.plannedLines}',
    );
  }
}
