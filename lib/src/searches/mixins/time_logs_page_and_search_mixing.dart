import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psp_admin/src/models/time_logs_model.dart';
import 'package:psp_admin/src/pages/time_logs/time_log_detail_page.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin TimeLogsPageAndSearchMixing {
  Widget buildItemList(BuildContext context, TimeLogModel timeLog,
      {Function closeSearch}) {
    return CustomListTile(
      title: Constants.PHASES[timeLog.phasesId],
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        if (closeSearch != null) closeSearch();
        Navigator.pushNamed(context, TimeLogDetailPage.ROUTE_NAME,
            arguments: timeLog);
      },
      subtitle: Constants.format
          .format(DateTime.fromMillisecondsSinceEpoch(timeLog.startDate)),
    );
  }
}
