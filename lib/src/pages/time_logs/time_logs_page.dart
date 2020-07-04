import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/time_logs_bloc.dart';
import 'package:psp_admin/src/models/time_logs_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/search_time_logs.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

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

  Widget _body() => CommonListOfModels(
        stream: _timeLogsBloc.timeLogsStream,
        onRefresh: _onRefreshTimeLogs,
        scaffoldState: _scaffoldKey.currentState,
        buildItemList: (items, index) => _buildItemList(items[index]),
      );

  Widget _buildItemList(TimeLogModel timeLog) {
    return CustomListTile(
      title: 'id: ${timeLog.id}',
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () =>
          Navigator.pushNamed(context, 'timeLogDetail', arguments: timeLog),
      subtitle: timeLog.comments,
    );
  }

  Future<void> _onRefreshTimeLogs() async =>
      await _timeLogsBloc.getTimeLogs(true, _programId);
}
