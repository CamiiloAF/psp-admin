import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/base_parts_model.dart';
import 'package:psp_admin/src/pages/base_parts/base_part_detail_page.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin BasePartsPageAndSearchMixing {
  Widget buildItemList(BuildContext context, BasePartModel basePart,
      {Function closeSearch}) {
    return CustomListTile(
      title: 'id: ${basePart.id}',
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        if (closeSearch != null) closeSearch();
        Navigator.pushNamed(context, BasePartDetailPage.ROUTE_NAME,
            arguments: basePart);
      },
      subtitle:
          '${S.of(context).labelPlannedBaseLines} ${basePart.plannedLinesBase}',
    );
  }
}
