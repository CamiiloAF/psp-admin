import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/test_reports_model.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';

class TestReportDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).appBarTitleTestReports),
      body: _createBody(context),
    );
  }

  Widget _createBody(BuildContext context) {
    final TestReportModel testReport =
        ModalRoute.of(context).settings.arguments;
        
    final s = S.of(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            InputForm.buildReadOnlyInput(
                s.labelTestNumber, testReport.testNumber.toString()),
            InputForm.buildReadOnlyInput(s.labelName, testReport.testName),
            InputForm.buildReadOnlyInput(
                s.labelConditions, testReport.conditions),
            InputForm.buildReadOnlyInput(
                s.labelExpectedResult, testReport.expectedResult),
            InputForm.buildReadOnlyInput(
                s.labelCurrentResult, testReport.currentResult ?? ''),
            InputForm.buildReadOnlyInput(
                s.labelDescription, testReport.description ?? ''),
            InputForm.buildReadOnlyInput(
                s.labelObjective, testReport.objective),
          ],
        ),
      ),
    );
  }
}
