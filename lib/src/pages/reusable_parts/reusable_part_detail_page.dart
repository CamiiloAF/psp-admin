import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/reusable_parts_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/boxs.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class ReusablePartDetailPage extends StatelessWidget {
  static const ROUTE_NAME = 'reusable-parts-detail';

  static const _TYPE = 'type';
  static const _SIZE = 'size';
  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAutorizedScreen();

    final programBloc = Provider.of<BlocProvider>(context).programsBloc;
    ReusablePartModel reusablePart = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).appBarTitleReusableParts),
      body: Column(
        children: [
          OneLineBox(
            text: S.of(context).labelReusableProgram +
                programBloc.getProgramsBaseName(
                    reusablePart.programsReusablesId,
                    S.of(context).labelCanNotLoadProgramBaseName),
            haveBorderTop: false,
          ),
          OneLineBox(
            text: S.of(context).labeLinesPlanned +
                ': ' +
                '${reusablePart.plannedLines}',
            haveBorderTop: false,
          ),
          OneLineBox(
            text: S.of(context).labeLinesCurrent +
                ': ' +
                '${reusablePart.currentLines ?? ''}',
            haveBorderTop: false,
          ),
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
