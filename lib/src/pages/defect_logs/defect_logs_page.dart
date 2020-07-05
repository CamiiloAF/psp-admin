import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/defect_logs_bloc.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/searches/mixins/defect_logs_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_defect_logs.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class DefectLogsPage extends StatefulWidget {
  @override
  _DefectLogsPageState createState() => _DefectLogsPageState();
}

class _DefectLogsPageState extends State<DefectLogsPage>
    with DefectLogsPageAndSearchMixing {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DefectLogsBloc _defectLogsBloc;
  int _programId;

  @override
  void initState() {
    _defectLogsBloc = context.read<BlocProvider>().defectLogsBloc;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _programId = ModalRoute.of(context).settings.arguments;
    if (_defectLogsBloc.lastValueDefectLogsController == null) {
      _defectLogsBloc.getDefectLogs(false, _programId);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _defectLogsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isValidToken()) return NotAutorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: S.of(context).appBarTitleDefectLogs,
        searchDelegate: SearchDefectLogs(_defectLogsBloc),
      ),
      body: _body(),
    );
  }

  Widget _body() => CommonListOfModels(
        stream: _defectLogsBloc.defectLogsStream,
        onRefresh: _onRefreshDefectLogs,
        scaffoldKey: _scaffoldKey,
        buildItemList: (items, index) => buildItemList(context, items[index]),
      );

  Future<void> _onRefreshDefectLogs() async =>
      await _defectLogsBloc.getDefectLogs(true, _programId);
}
