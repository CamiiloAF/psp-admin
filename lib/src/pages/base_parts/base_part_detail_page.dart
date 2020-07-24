import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/base_parts_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';
import 'package:psp_admin/src/widgets/one_simple_row.dart';

class BasePartDetailPage extends StatelessWidget {
  static const ROUTE_NAME = 'base-parts-detail';

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();
    final s = S.of(context);

    final programBloc = Provider.of<BlocProvider>(context).programsBloc;
    BasePartModel basePart = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(title: s.appBarTitleBaseParts),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              OneSimpleRow(
                label: s.labelBaseProgram,
                text: programBloc.getProgramsBaseName(basePart.programsBaseId,
                  s.labelCanNotLoadProgramBaseName)
              ),
              _buildInputsForPlannedLines(s, basePart),
              _buildInputsForCurrentLines(s, basePart)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputsForPlannedLines(S s, BasePartModel basePart) {
    return Column(
      children: [
        InputForm.buildReadOnlyInput(
          s.labelPlannedLinesBase,
          '${basePart?.plannedLinesBase ?? ''}',
        ),
        InputForm.buildReadOnlyInput(
          s.labelPlannedLinesDeleted,
          '${basePart?.plannedLinesDeleted ?? ''}',
        ),
        InputForm.buildReadOnlyInput(
          s.labelPlannedLinesEdits,
          '${basePart?.plannedLinesEdits ?? ''}',
        ),
        InputForm.buildReadOnlyInput(
          s.labelPlannedLinesAdded,
          '${basePart?.plannedLinesAdded ?? ''}',
        ),
      ],
    );
  }

  Widget _buildInputsForCurrentLines(S s, BasePartModel basePart) {
    return Column(
      children: [
        InputForm.buildReadOnlyInput(
          s.labelCurrentLinesBase,
          '${basePart?.currentLinesBase ?? ''}',
        ),
        InputForm.buildReadOnlyInput(
          s.labelCurrentLinesDeleted,
          '${basePart?.currentLinesDeleted ?? ''}',
        ),
        InputForm.buildReadOnlyInput(
          s.labelCurrentLinesEdits,
          '${basePart?.currentLinesEdits ?? ''}',
        ),
        InputForm.buildReadOnlyInput(
          s.labelCurrentLinesAdded,
          '${basePart?.currentLinesAdded ?? ''}',
        ),
      ],
    );
  }
}
