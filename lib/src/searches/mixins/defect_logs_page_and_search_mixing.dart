import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psp_admin/src/models/defect_logs_model.dart';
import 'package:psp_admin/src/pages/defect_logs/defect_log_detail_page.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin DefectLogsPageAndSearchMixing {
  Widget buildItemList(BuildContext context, DefectLogModel defectLog,
      {Function closeSearch}) {
    return CustomListTile(
      title: 'id: ${defectLog.id}',
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        if (closeSearch != null) closeSearch();
        Navigator.pushNamed(context, DefectLogDetailPage.ROUTE_NAME,
            arguments: defectLog);
      },
      subtitle: defectLog.description,
    );
  }
}
