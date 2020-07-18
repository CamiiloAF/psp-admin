import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/analysis_tools_bloc.dart';
import 'package:psp_admin/src/pages/analysis_tools/charts_builder.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';

class AnalysisToolsPage extends StatefulWidget {
  static const ROUTE_NAME = 'analysis-tools';

  @override
  _AnalysisToolsPageState createState() => _AnalysisToolsPageState();
}

class _AnalysisToolsPageState extends State<AnalysisToolsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AnalysisToolsBloc _analysisToolsBloc;

  int _userId;

  @override
  void initState() {
    _analysisToolsBloc = context.read<BlocProvider>().analysisToolsBloc;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userId = ModalRoute.of(context).settings.arguments;

    if (_analysisToolsBloc.lastValueAnalysisToolsModelController == null) {
      _analysisToolsBloc.getAnalysisTools(_userId);
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _analysisToolsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();

    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(title: S.of(context).appBarTitleAnalysisTools),
        body: _buildBody());
  }

  Widget _buildBody() => CommonListOfModels(
        stream: _analysisToolsBloc.analysisToolsStream,
        onRefresh: _onRefreshAnalysisTools,
        scaffoldKey: _scaffoldKey,
        buildListView: (items) => buildListView(),
      );

  Widget buildListView() {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;
    final chartsBuilder = ChartsBuilder(isDarkTheme: isDarkTheme);

    final s = S.of(context);

    return ListView(
      children: [
        chartsBuilder.build(s.titleSizeOfPrograms,
            [..._analysisToolsBloc.getTotalSizesByProgram()]),
        chartsBuilder.build(s.titleTotalTimes,
            [..._analysisToolsBloc.getTotalTimesByProgram()]),
        chartsBuilder.build(s.titleTotalDefects,
            [..._analysisToolsBloc.getTotalDefectsByProgram()]),
        chartsBuilder.build(s.titleDefectsInjectedByPhase,
            [..._analysisToolsBloc.getDefectsInjectedByPhase()]),
        chartsBuilder.build(s.titleDefectsRemovedByPhase,
            [..._analysisToolsBloc.getDefectsRemovedByPhase()]),
      ],
    );
  }

  Future<void> _onRefreshAnalysisTools() async =>
      await _analysisToolsBloc.getAnalysisTools(_userId);
}
