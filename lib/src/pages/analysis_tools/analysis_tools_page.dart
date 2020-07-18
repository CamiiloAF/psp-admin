import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/pages/analysis_tools/charts_builder.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';

class AnalysisToolsPage extends StatelessWidget {
  static const ROUTE_NAME = 'analysis-tools';

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();

    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;
    final chartsBuilder = ChartsBuilder(isDarkTheme: isDarkTheme);

    final s = S.of(context);

    final analysisToolsBloc =
        Provider.of<BlocProvider>(context).analysisToolsBloc;

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).appBarTitleAnalysisTools),
      body: ListView(
        children: [
          chartsBuilder.build(s.titleSizeOfPrograms,
              [...analysisToolsBloc.getTotalSizesByProgram()]),
          chartsBuilder.build(s.titleTotalTimes,
              [...analysisToolsBloc.getTotalTimesByProgram()]),
          chartsBuilder.build(s.titleTotalDefects,
              [...analysisToolsBloc.getTotalDefectsByProgram()]),
          chartsBuilder.build(s.titleDefectsInjectedByPhase,
              [...analysisToolsBloc.getDefectsInjectedByPhase()]),
          chartsBuilder.build(s.titleDefectsRemovedByPhase,
              [...analysisToolsBloc.getDefectsRemovedByPhase()]),
        ],
      ),
    );
  }
}
