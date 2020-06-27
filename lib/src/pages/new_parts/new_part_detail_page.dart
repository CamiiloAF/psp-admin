import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/new_parts_model.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/widgets/boxs.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';

class NewPartDetailPage extends StatelessWidget {
  static const _TYPE = 'type';
  static const _SIZE = 'size';
  @override
  Widget build(BuildContext context) {
    NewPartModel newPart = ModalRoute.of(context).settings.arguments;

    final typeAndSize = getTypeAndSyze(context, newPart.typesSizesId);

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).appBarTitleNewParts),
      body: Column(
        children: [
          OneLineBox(
            text: S.of(context).labelType + typeAndSize[_TYPE],
            haveBorderTop: false,
          ),
          OneLineBox(
            text: S.of(context).labelSize + typeAndSize[_SIZE],
            haveBorderTop: false,
          ),
          OneLineBox(
            text: S.of(context).labelName + ': ' + newPart.name,
            haveBorderTop: false,
            haveBorderBottom: false,
          ),
          TableOneLineBox(
              textTopLeft:
                  S.of(context).labeLinesPlanned + ': ${newPart.plannedLines}',
              textTopRigth: S.of(context).labeMethodsPlanned +
                  ': ${newPart.numberMethodsPlanned}',
              textBottomLeft: S.of(context).labeLinesCurrent +
                  ': ${newPart.currentLines ?? ''}',
              textBottomRigth: S.of(context).labeMethodsCurrent +
                  ': ${newPart.numberMethodsCurrent ?? ''}')
        ],
      ),
    );
  }

  Map<String, String> getTypeAndSyze(BuildContext context, int typesSizesId) {
    var typesSizes = Constants.NEW_PART_TYPES_SIZE[typesSizesId];

    final typesSizesSplit = typesSizes.split('-');

    return {
      _TYPE: typesSizesSplit[0].toUpperCase(),
      _SIZE: typesSizesSplit[1].toUpperCase(),
    };
  }
}
