import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/time_logs_bloc.dart';
import 'package:psp_admin/src/models/time_logs_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/providers/models/fab_model.dart';
import 'package:psp_admin/src/utils/searchs/search_time_logs.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class TimeLogsPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final int programId = ModalRoute.of(context).settings.arguments;

    final timeLogsBloc = Provider.of<BlocProvider>(context).timeLogsBloc;
    timeLogsBloc.getTimeLogs(false, programId);

    if (!isValidToken()) return NotAutorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: S.of(context).appBarTitleTimeLogs,
        searchDelegate: SearchTimeLogs(timeLogsBloc),
      ),
      body: _body(timeLogsBloc, programId),
    );
  }

  Widget _body(TimeLogsBloc timeLogsBloc, int programId) {
    return StreamBuilder(
      stream: timeLogsBloc.timeLogStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<TimeLogModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final timeLogs = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (timeLogs.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshTimeLogs(context, timeLogsBloc, programId),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshTimeLogs(context, timeLogsBloc, programId),
          child: _buildListView(timeLogs),
        );
      },
    );
  }

  ListView _buildListView(List<TimeLogModel> timeLogs) {
    return ListView.separated(
        itemCount: timeLogs.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(timeLogs, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<TimeLogModel> timeLogs, int i, BuildContext context) {
    return CustomListTile(
      title: 'id: ${timeLogs[i].id}',
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => {
        // Navigator.pushNamed(context, 'programItems', arguments: timeLogs[i])
      },
      subtitle: timeLogs[i].comments,
    );
  }

  Future<void> _refreshTimeLogs(
      BuildContext context, TimeLogsBloc timeLogsBloc, int programId) async {
    await timeLogsBloc.getTimeLogs(true, programId);
  }
}
