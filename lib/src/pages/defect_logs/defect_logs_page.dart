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

class DefectLogsPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final int programId = ModalRoute.of(context).settings.arguments;

    final defectLogsBloc = Provider.of<BlocProvider>(context).defectLogsBloc;
    defectLogsBloc.getDefectLogs(false, programId);

    if (!isValidToken()) return NotAutorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: S.of(context).appBarTitleDefectLogs,
        searchDelegate: SearchDefectLogs(defectLogsBloc),
      ),
      body: _body(defectLogsBloc, programId),
    );
  }

  Widget _body(DefectLogsBloc defectLogsBloc, int programId) {
    return StreamBuilder(
      stream: defectLogsBloc.defectLogStream,
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
            onRefresh: () =>
                _refreshDefectLogs(context, defectLogsBloc, programId),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              _refreshDefectLogs(context, defectLogsBloc, programId),
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
        Navigator.pushNamed(context, 'defectLogDetail', arguments: defectLogs[i])
      },
      subtitle: defectLogs[i].description,
    );
  }

  Future<void> _refreshDefectLogs(BuildContext context,
      DefectLogsBloc defectLogsBloc, int programId) async {
    await defectLogsBloc.getDefectLogs(true, programId);
  }
}
