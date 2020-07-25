import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/program_summary_bloc.dart';
import 'package:psp_admin/src/pages/program_summary/program_summary_card.dart';
import 'package:psp_admin/src/pages/program_summary/summary_card.dart';
import 'package:psp_admin/src/pages/program_summary/time_in_phase_mixin_with_defects.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';

class ProgramSummary extends StatelessWidget {
  static const ROUTE_NAME = 'program-summary';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final programId = ModalRoute.of(context).settings.arguments;

    final s = S.of(context);

    final programSummaryBloc =
        Provider.of<BlocProvider>(context).programSummaryBloc;

    programSummaryBloc.getProgramSummary(programId);

    return Scaffold(
      appBar: CustomAppBar(title: s.appBarTitleProgramSummary),
      body: Container(
        margin: EdgeInsets.all(12),
        child: CommonListOfModels(
          scaffoldKey: _scaffoldKey,
          stream: programSummaryBloc.programSummaryStream,
          buildListView: (items) => buildListView(items[0], s),
          onRefresh: () => onRefresh(programSummaryBloc, programId),
        ),
      ),
    );
  }

  Widget buildListView(dynamic programSummaryModel, S s) {
        return ListView(
            children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text('${s.labelLanguage}: ${programSummaryModel.language}', style: TextStyle(fontSize: 20),),
        ),
              _ProgramSizeSummary(programLines: programSummaryModel.programLines,),
        SummaryCard(
          title: s.titleTimePerPhase,
          items: programSummaryModel.timePhase,
        ),
        SummaryCard(
          title: s.titleDefectsInjectedPerPhase,
          items: programSummaryModel.defectsInjected,
        ),
        SummaryCard(
          title: s.titleDefectsRemovedPerPhase,
          items: programSummaryModel.defectsRemoved,
        ),
            ],
          );
  }

  Future<void> onRefresh(
          ProgramSummaryBloc programSummaryBloc, int programId) async =>
      programSummaryBloc.getProgramSummary(programId);
}

class _ProgramSizeSummary extends StatelessWidget
    with TimeInPhaseMixinWithDefects {
  final Map<String, double> programLines;

  const _ProgramSizeSummary({this.programLines});

  @override
  Widget build(BuildContext context) {
    if(programLines == null || programLines.isEmpty) return Container();
    final s = S.of(context);

    return ProgramSummaryCard(
        title: s.titleProgramSize, items: _buildItems(programLines, s));
  }

  List<TableRow> _buildItems(Map<String, double> programLines, S s) {
    return [
      buildTableRow('', planned: s.labelPlanned, current: s.labelCurrent),
      buildTableRow(s.labelBase, planned: programLines['base_planned'],
          current: programLines['base_current']),
      buildTableRow(s.labelDeleted,planned: programLines['deleted_planned'],
current:          programLines['deleted_current']),
      buildTableRow(s.labelModified, planned:programLines['modified_planned'],
          current:programLines['modified_current']),
      buildTableRow(s.labelAdded, planned:programLines['added_planned'],
          current:programLines['added_current']),
      buildTableRow(s.labelReused, planned:programLines['reused_planned'],
          current:programLines['reused_current']),
      buildTableRow(s.labelNew, planned:programLines['new_planned_lines'],
          current:programLines['new_current_lines']),
      buildTableRow(
          s.labelTotal,
          planned:_calculateTotalLines(programLines, isPlanned: true),
          current:_calculateTotalLines(programLines, isPlanned: false)),
    ];
  }

  double _calculateTotalLines(Map<String, double> programLines,
      {bool isPlanned}) {
    var total = 0.0;

    final typeLines = (isPlanned) ? 'planned' : 'current';

    total += programLines['base_$typeLines'];
    total += programLines['deleted_$typeLines'];
    total += programLines['modified_$typeLines'];
    total += programLines['added_$typeLines'];
    total += programLines['new_${typeLines}_lines'];

    return total;
  }
}
