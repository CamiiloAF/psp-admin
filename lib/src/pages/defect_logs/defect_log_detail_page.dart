import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/defect_logs_model.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class DefectLogDetailPage extends StatelessWidget {
  static const ROUTE_NAME = 'defect-logs-detail';

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAutorizedScreen();

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).appBarTitleDefectLogs),
      body: _createBody(context),
    );
  }

  Widget _createBody(BuildContext context) {
    final DefectLogModel defectLog = ModalRoute.of(context).settings.arguments;
    final s = S.of(context);

    final phaseRemoved = (defectLog.phaseRemovedId != null)
        ? Constants.PHASES[defectLog.phaseRemovedId]
        : s.labelNone;

    final startDate = Constants.format
        .format(DateTime.fromMillisecondsSinceEpoch(defectLog.startDate));

    final finishDate = (defectLog.finishDate != null)
        ? Constants.format
            .format(DateTime.fromMillisecondsSinceEpoch(defectLog.finishDate))
        : '';

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            InputForm.buildReadOnlyInput(s.labelIdChainedDefectLog,
                '${defectLog.defectLogChainedId ?? s.labelNone}'),
            InputForm.buildReadOnlyInput(s.labelStandardDefect,
                Constants.STANDARD_DEFECTS[defectLog.standardDefectsId]),
            InputForm.buildReadOnlyInput(
                s.labelPhaseAdded, Constants.PHASES[defectLog.phaseAddedId]),
            InputForm.buildReadOnlyInput(s.labelPhaseRemoved, phaseRemoved),
            InputForm.buildReadOnlyInput(
                s.labelDescription, defectLog.description),
            InputForm.buildReadOnlyInput(
                s.labelSolution, defectLog.solution ?? ''),
            InputForm.buildReadOnlyInput(s.labelStartDate, startDate),
            InputForm.buildReadOnlyInput(s.labelFinishDate, finishDate),
            InputForm.buildReadOnlyInput(s.labelTimeForRepair,
                defectLog.timeForRepair?.toString() ?? ''),
          ],
        ),
      ),
    );
  }
}
