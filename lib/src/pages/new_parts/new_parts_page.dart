import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/new_parts_bloc.dart';
import 'package:psp_admin/src/models/new_parts_model.dart';

import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/providers/models/fab_model.dart';
import 'package:psp_admin/src/utils/searchs/search_new_parts.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class NewPartsPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final int programId = ModalRoute.of(context).settings.arguments;

    final newPartsBloc = Provider.of<BlocProvider>(context).newPartsBloc;
    newPartsBloc.getNewParts(false, programId);

    if (!isValidToken()) return NotAutorizedScreen();

    return ChangeNotifierProvider(
        create: (_) => FabModel(),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            title: S.of(context).appBarTitleNewParts,
            searchDelegate: SearchNewParts(newPartsBloc),
          ),
          body: _body(newPartsBloc, programId),
        ));
  }

  Widget _body(NewPartsBloc newPartsBloc, int programId) {
    return StreamBuilder(
      stream: newPartsBloc.newPartsStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<NewPartModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final newParts = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (newParts.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshNewParts(context, newPartsBloc, programId),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshNewParts(context, newPartsBloc, programId),
          child: _buildListView(newParts),
        );
      },
    );
  }

  ListView _buildListView(List<NewPartModel> newParts) {
    return ListView.separated(
        itemCount: newParts.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(newParts, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<NewPartModel> newParts, int i, BuildContext context) {
    return CustomListTile(
      title: newParts[i].name,
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => {
        Navigator.pushNamed(context, 'newPartsDetail', arguments: newParts[i])
      },
      subtitle:
          '${S.of(context).labelPlannedLines} ${newParts[i].plannedLines}',
    );
  }

  Future<void> _refreshNewParts(
      BuildContext context, NewPartsBloc newPartsBloc, int programId) async {
    await newPartsBloc.getNewParts(true, programId);
  }
}
