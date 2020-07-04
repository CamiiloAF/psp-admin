import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/defect_logs_bloc.dart';
import 'package:psp_admin/src/models/defect_logs_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/search_defect_logs.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class DefectLogsPage extends StatefulWidget {
  @override
  _DefectLogsPageState createState() => _DefectLogsPageState();
}

class _DefectLogsPageState extends State<DefectLogsPage> {
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

  Widget _body() {
    return StreamBuilder(
      stream: _defectLogsBloc.defectLogStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<DefectLogModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final defectLogs = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (defectLogs.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshDefectLogs(),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshDefectLogs(),
          child: _buildListView(defectLogs),
        );
      },
    );
  }

  ListView _buildListView(List<DefectLogModel> defectLogs) {
    return ListView.separated(
        itemCount: defectLogs.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(defectLogs, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<DefectLogModel> defectLogs, int i, BuildContext context) {
    return CustomListTile(
      title: 'id: ${defectLogs[i].id}',
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => {
        Navigator.pushNamed(context, 'defectLogDetail',
            arguments: defectLogs[i])
      },
      subtitle: defectLogs[i].description,
    );
  }

  Future<void> _refreshDefectLogs() async =>
      await _defectLogsBloc.getDefectLogs(true, _programId);
}
