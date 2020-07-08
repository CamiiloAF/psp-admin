import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/test_reports_bloc.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/searches/mixins/test_reports_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_test_reports.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class TestReportsPage extends StatefulWidget {
  @override
  _TestReportsPageState createState() => _TestReportsPageState();
}

class _TestReportsPageState extends State<TestReportsPage>
    with TestReportsPageAndSearchMixing {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TestReportsBloc _testReportsBloc;
  int _programId;

  @override
  void initState() {
    _testReportsBloc = context.read<BlocProvider>().testReportsBloc;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _programId = ModalRoute.of(context).settings.arguments;
    if (_testReportsBloc.lastValueTestReportsController == null) {
      _testReportsBloc.getTestReports(false, _programId);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _testReportsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAutorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: S.of(context).appBarTitleTestReports,
        searchDelegate: SearchTestReports(_testReportsBloc),
      ),
      body: _body(),
    );
  }

  Widget _body() => CommonListOfModels(
        stream: _testReportsBloc.testReportsStream,
        onRefresh: _onRefreshTestReports,
        scaffoldKey: _scaffoldKey,
        buildItemList: (items, index) => buildItemList(context, items[index]),
      );

  Future<void> _onRefreshTestReports() async =>
      await _testReportsBloc.getTestReports(true, _programId);
}
