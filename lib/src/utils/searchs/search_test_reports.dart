import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/test_reports_bloc.dart';
import 'package:psp_admin/src/models/test_reports_model.dart';
import 'package:psp_admin/src/utils/searchs/search_delegate.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

class SearchTestReports extends DataSearch {
  final TestReportsBloc _testReportsBloc;

  SearchTestReports(this._testReportsBloc);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    final testReports =
        _testReportsBloc?.lastValueTestReportsController?.item2 ?? [];
    if (testReports.isNotEmpty && testReports != null) {
      return Container(
          child: ListView(
        children: testReports
            .where((testReport) => _areItemContainQuery(testReport, query))
            .map((testReport) {
          return CustomListTile(
            title: testReport.testName,
            trailing:
                Text('${S.of(context).labelNumber} ${testReport.testNumber}'),
            onTap: () => {
              // Navigator.pushNamed(context, 'programItems', arguments: testReports[i])
            },
            subtitle: testReport.objective,
          );
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(TestReportModel testReport, String query) {
    return '${testReport.testNumber}'.contains(query.toLowerCase()) ||
            testReport.testName.toLowerCase().contains(query.toLowerCase()) ||
            testReport.objective.toLowerCase().contains(query.toLowerCase())
        ? true
        : false;
  }
}
