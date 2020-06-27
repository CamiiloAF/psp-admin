import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/test_reports_bloc.dart';
import 'package:psp_admin/src/models/test_reports_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/search_test_reports.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class TestReportsPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final int programId = ModalRoute.of(context).settings.arguments;

    final testReportsBloc = Provider.of<BlocProvider>(context).testReportsBloc;
    testReportsBloc.getTestReports(false, programId);

    if (!isValidToken()) return NotAutorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: S.of(context).appBarTitleTestReports,
        searchDelegate: SearchTestReports(testReportsBloc),
      ),
      body: _body(testReportsBloc, programId),
    );
  }

  Widget _body(TestReportsBloc testReportsBloc, int programId) {
    return StreamBuilder(
      stream: testReportsBloc.testReportsStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<TestReportModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final testReports = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (testReports.isEmpty) {
          return RefreshIndicator(
            onRefresh: () =>
                _refreshTestReports(context, testReportsBloc, programId),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              _refreshTestReports(context, testReportsBloc, programId),
          child: _buildListView(testReports),
        );
      },
    );
  }

  ListView _buildListView(List<TestReportModel> testReports) {
    return ListView.separated(
        itemCount: testReports.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(testReports, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<TestReportModel> testReports, int i, BuildContext context) {
    return CustomListTile(
      title: testReports[i].testName,
      trailing:
          Text('${S.of(context).labelNumber} ${testReports[i].testNumber}'),
      onTap: () => {
        Navigator.pushNamed(context, 'programItems', arguments: testReports[i])
      },
      subtitle: testReports[i].objective,
    );
  }

  Future<void> _refreshTestReports(BuildContext context,
      TestReportsBloc testReportsBloc, int programId) async {
    await testReportsBloc.getTestReports(true, programId);
  }
}
