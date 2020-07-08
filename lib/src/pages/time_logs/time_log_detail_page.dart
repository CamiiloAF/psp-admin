import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/time_logs_model.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class TimeLogDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAutorizedScreen();

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).appBarTitleTimeLogs),
      body: _createBody(context),
    );
  }

  Widget _createBody(BuildContext context) {
    final TimeLogModel timeLog = ModalRoute.of(context).settings.arguments;
    final s = S.of(context);
    final startDate = Constants.format
        .format(DateTime.fromMillisecondsSinceEpoch(timeLog.startDate));

    final finishDate = (timeLog.finishDate != null)
        ? Constants.format
            .format(DateTime.fromMillisecondsSinceEpoch(timeLog.finishDate))
        : '';

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            InputForm.buildReadOnlyInput(
                s.labelPhase, Constants.PHASES[timeLog.phasesId]),
            InputForm.buildReadOnlyInput(s.labelStartDate, startDate),
            InputForm.buildReadOnlyInput(s.labelFinishDate, finishDate),
            InputForm.buildReadOnlyInput(
                s.labelDeltaTime, timeLog.deltaTime?.toString() ?? ''),
            InputForm.buildReadOnlyInput(
                s.labelComments, timeLog.comments ?? ''),
          ],
        ),
      ),
    );
  }
}
