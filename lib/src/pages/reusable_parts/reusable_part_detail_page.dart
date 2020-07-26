import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/reusable_parts_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';

class ReusablePartDetailPage extends StatelessWidget {
  static const ROUTE_NAME = 'reusable-parts-detail';

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();

    final programBloc = Provider.of<BlocProvider>(context).programsBloc;
    final s = S.of(context);
    ReusablePartModel reusablePart = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(title: s.appBarTitleReusableParts),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              s.labelReusableProgram,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
                programBloc.getProgramsBaseName(
                    reusablePart.programsReusablesId,
                    s.labelCanNotLoadProgramBaseName),
                overflow: TextOverflow.ellipsis),
            InputForm.buildReadOnlyInput(S.of(context).labelPlannedLinesBase,
                '${reusablePart?.plannedLines ?? ''}'),
            InputForm.buildReadOnlyInput(
              S.of(context).labelCurrentLinesBase,
              '${reusablePart?.currentLines ?? ''}',
            ),
          ],
        ),
      ),
    );
  }
}
