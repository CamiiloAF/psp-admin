import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/new_parts_model.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';
import 'package:psp_admin/src/widgets/one_simple_row.dart';

class NewPartDetailPage extends StatelessWidget {
  static const ROUTE_NAME = 'new-parts-detail';

  static const _TYPE = 'type';
  static const _SIZE = 'size';

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();

    final s = S.of(context);

    NewPartModel newPart = ModalRoute.of(context).settings.arguments;

    final typeAndSize = getTypeAndSize(context, newPart.typesSizesId);

    return Scaffold(
      appBar: CustomAppBar(title: s.appBarTitleNewParts),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            SizedBox(height: 10,),
            OneSimpleRow(label: s.labelType, text: typeAndSize[_TYPE]),
            SizedBox(height: 10,),
            OneSimpleRow(label: s.labelSize, text: typeAndSize[_SIZE]),
            SizedBox(height: 10,),
            OneSimpleRow(
              label: s.labelName + ': ',
              text: newPart.name,
            ),
            _buildPlannedInputs(s, newPart),
            _buildCurrentInputs(s, newPart),
          ],
        ),
      ),
    );
  }

  Widget _buildPlannedInputs(S s, NewPartModel newPart) {
    return Column(
      children: [
        InputForm.buildReadOnlyInput(
          s.labelPlannedLinesBase,
          '${newPart?.plannedLines ?? ''}',
        ),
        InputForm.buildReadOnlyInput(
          s.labelMethodsPlanned,
          '${newPart?.numberMethodsPlanned ?? ''}',
        ),
      ],
    );
  }

  Widget _buildCurrentInputs(S s, NewPartModel newPart) {
    return Column(
      children: [
        InputForm.buildReadOnlyInput(
          s.labelCurrentLinesBase,
          '${newPart?.currentLines ?? ''}',
        ),
        InputForm.buildReadOnlyInput(
          s.labelMethodsCurrent,
          '${newPart?.numberMethodsCurrent ?? ''}',
        ),
      ],
    );
  }

  Map<String, String> getTypeAndSize(BuildContext context, int typesSizesId) {
    var typesSizes = Constants.NEW_PART_TYPES_SIZE[typesSizesId];

    final typesSizesSplit = typesSizes.split('-');

    return {
      _TYPE: typesSizesSplit[0].toUpperCase(),
      _SIZE: typesSizesSplit[1].toUpperCase(),
    };
  }
}
