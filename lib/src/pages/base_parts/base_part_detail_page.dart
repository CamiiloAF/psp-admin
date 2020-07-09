import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/base_parts_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/boxs.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class BasePartDetailPage extends StatelessWidget {
  static const ROUTE_NAME = 'base-parts-detail';
  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAutorizedScreen();

    final programBloc = Provider.of<BlocProvider>(context).programsBloc;
    BasePartModel basePart = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).appBarTitleBaseParts),
      body: Column(
        children: [
          OneLineBox(
            text: S.of(context).labelBaseProgram +
                programBloc.getProgramsBaseName(basePart.programsBaseId,
                    S.of(context).labelCanNotLoadProgramBaseName),
            haveBorderTop: false,
          ),
          _buildTableWithTitle(context, true, basePart),
          _buildTableWithTitle(context, false, basePart),
        ],
      ),
    );
  }

  Widget _buildTableWithTitle(
      BuildContext context, bool isForPlannedLines, BasePartModel basePart) {
    final title = (isForPlannedLines)
        ? S.of(context).labeLinesPlanned
        : S.of(context).labeLinesCurrent;

    final baseLines = (isForPlannedLines)
        ? basePart.plannedLinesBase
        : basePart.currentLinesBase ?? '';
    final deleteLines = (isForPlannedLines)
        ? basePart.plannedLinesDeleted
        : basePart.currentLinesDeleted ?? '';
    final editLines = (isForPlannedLines)
        ? basePart.plannedLinesEdits
        : basePart.currentLinesEdits ?? '';
    final addedLines = (isForPlannedLines)
        ? basePart.plannedLinesAdded
        : basePart.currentLinesAdded ?? '';

    return _TableWithTitleOneLineBox(
      title: title,
      baseLines: '${baseLines}',
      deleteLines: '${deleteLines}',
      editLines: '${editLines}',
      addedLines: '${addedLines}',
    );
  }
}

class _TableWithTitleOneLineBox extends StatelessWidget {
  final String title;
  final String baseLines;
  final String deleteLines;
  final String editLines;
  final String addedLines;

  const _TableWithTitleOneLineBox(
      {@required this.title,
      @required this.baseLines,
      @required this.deleteLines,
      @required this.editLines,
      @required this.addedLines});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        TableOneLineBox(
          textTopLeft: S.of(context).labeLinesBase + baseLines,
          textTopRigth: S.of(context).labeLinesDeleted + deleteLines,
          textBottomLeft: S.of(context).labeLinesEdits + editLines,
          textBottomRigth: S.of(context).labeLinesAdded + addedLines,
        ),
      ],
    );
  }
}
