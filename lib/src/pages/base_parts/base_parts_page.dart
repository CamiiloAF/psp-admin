import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/base_parts_bloc.dart';
import 'package:psp_admin/src/models/base_parts_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/providers/models/fab_model.dart';
import 'package:psp_admin/src/utils/searchs/search_base_parts.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class BasePartsPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final int programId = ModalRoute.of(context).settings.arguments;

    final basePartsBloc = Provider.of<BlocProvider>(context).basePartsBloc;
    basePartsBloc.getBaseParts(false, programId);

    if (!isValidToken()) return NotAutorizedScreen();

    return ChangeNotifierProvider(
        create: (_) => FabModel(),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            title: S.of(context).appBarTitleBaseParts,
            searchDelegate: SearchBaseParts(basePartsBloc),
          ),
          body: _body(basePartsBloc, programId),
        ));
  }

  Widget _body(BasePartsBloc basePartsBloc, int programId) {
    return StreamBuilder(
      stream: basePartsBloc.basePartsStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<BasePartModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final baseParts = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (baseParts.isEmpty) {
          return RefreshIndicator(
            onRefresh: () =>
                _refreshBaseParts(context, basePartsBloc, programId),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshBaseParts(context, basePartsBloc, programId),
          child: _buildListView(baseParts),
        );
      },
    );
  }

  ListView _buildListView(List<BasePartModel> baseParts) {
    return ListView.separated(
        itemCount: baseParts.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(baseParts, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<BasePartModel> baseParts, int i, BuildContext context) {
    return CustomListTile(
      title: 'id: ${baseParts[i].id}',
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => {
        Navigator.pushNamed(context, 'basePartsDetail', arguments: baseParts[i])
      },
      subtitle:
          '${S.of(context).labelPlannedBaseLines} ${baseParts[i].plannedLinesBase}',
    );
  }

  Future<void> _refreshBaseParts(
      BuildContext context, BasePartsBloc basePartsBloc, int programId) async {
    await basePartsBloc.getBaseParts(true, programId);
  }
}
