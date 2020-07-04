import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/time_logs_bloc.dart';
import 'package:psp_admin/src/models/time_logs_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/search_time_logs.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class TimeLogsPage extends StatefulWidget {
  @override
  _TimeLogsPageState createState() => _TimeLogsPageState();
}

class _TimeLogsPageState extends State<TimeLogsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TimeLogsBloc _timeLogsBloc;
  int _programId;

  @override
  void initState() {
    _timeLogsBloc = context.read<BlocProvider>().timeLogsBloc;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _programId = ModalRoute.of(context).settings.arguments;
    if (_timeLogsBloc.lastValueTimeLogsController == null) {
      _timeLogsBloc.getTimeLogs(false, _programId);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timeLogsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isValidToken()) return NotAutorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: S.of(context).appBarTitleTimeLogs,
        searchDelegate: SearchTimeLogs(_timeLogsBloc),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder(
      stream: _timeLogsBloc.timeLogStream,
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
            onRefresh: () => _refreshTimeLogs(),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshTimeLogs(),
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
        Navigator.pushNamed(context, 'timeLogDetail', arguments: timeLogs[i])
      },
      subtitle: timeLogs[i].comments,
    );
  }

  Future<void> _refreshTimeLogs() async =>
      await _timeLogsBloc.getTimeLogs(true, _programId);
}
