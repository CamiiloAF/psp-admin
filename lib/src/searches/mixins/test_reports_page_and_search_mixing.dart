import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/test_reports_model.dart';
import 'package:psp_admin/src/pages/test_reports/test_report_detail_page.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin TestReportsPageAndSearchMixing {
  Widget buildItemList(BuildContext context, TestReportModel testReport,
      {Function closeSearch}) {
    return CustomListTile(
      title: testReport.testName,
      trailing: Text('${S.of(context).labelNumber} ${testReport.testNumber}'),
      onTap: () {
        if (closeSearch != null) closeSearch();
        Navigator.pushNamed(context, TestReportDetailPage.ROUTE_NAME,
            arguments: testReport);
      },
      subtitle: testReport.objective,
    );
  }
}
