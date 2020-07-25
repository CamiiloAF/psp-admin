import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/summary/summary.dart';
import 'package:psp_admin/src/pages/program_summary/program_summary_card.dart';
import 'package:psp_admin/src/pages/program_summary/time_in_phase_mixin_with_defects.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/utils.dart';

class SummaryCard extends StatelessWidget with TimeInPhaseMixinWithDefects {
  final List<Summary> items;
  final String title;

  const SummaryCard({@required this.items, @required this.title});

  @override
  Widget build(BuildContext context) {
    if (isNullOrEmpty(items)) return Container();

    final s = S.of(context);

    final totalPlanned =
        calculateTotal(items.map((element) => element.planning).toList());

    final totalCurrent =
        calculateTotal(items.map((element) => element.current).toList());

    final totalToDate =
        calculateTotal(items.map((element) => element.toDate).toList());

    final tableRowItems = items
        .map((item) => buildTableRow(Constants.PHASES[item.phaseId],
            planned:item.planning, current:item.current,
            toDate: item.toDate, percent: '${item.percent} %'))
        .toList();

    return ProgramSummaryCard(title: title, items: [
      buildTableRow(null,planned: (totalPlanned != null) ?s.labelPlanned:null,current: s.labelCurrent,
          toDate: s.labelToDate, percent: s.labelPercent),
      ...tableRowItems,
      buildTableRow(s.labelTotal, planned:(totalPlanned != null)? totalPlanned:null, current:totalCurrent,
          toDate: totalToDate, percent: '100 %'),
    ]);
  }
}
