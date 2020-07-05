import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/reusable_parts_model.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin ReusablePartsPageAndSearchMixing {
  Widget buildItemList(BuildContext context, ReusablePartModel reusablePart,
      {Function closeSearch}) {
    return CustomListTile(
      title: '${S.of(context).labelPlannedLines} ${reusablePart.plannedLines}',
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        if (closeSearch != null) closeSearch();
        Navigator.pushNamed(context, 'reusablePartsDetail',
            arguments: reusablePart);
      },
    );
  }
}
