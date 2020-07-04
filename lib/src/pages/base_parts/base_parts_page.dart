import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/base_parts_bloc.dart';
import 'package:psp_admin/src/models/base_parts_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/search_base_parts.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class BasePartsPage extends StatefulWidget {
  @override
  _BasePartsPageState createState() => _BasePartsPageState();
}

class _BasePartsPageState extends State<BasePartsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  BasePartsBloc _basePartsBloc;
  int _programId;

  @override
  void initState() {
    _basePartsBloc = context.read<BlocProvider>().basePartsBloc;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _programId = ModalRoute.of(context).settings.arguments;
    if (_basePartsBloc.lastValueBasePartsController == null) {
      _basePartsBloc.getBaseParts(false, _programId);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _basePartsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isValidToken()) return NotAutorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: S.of(context).appBarTitleBaseParts,
        searchDelegate: SearchBaseParts(_basePartsBloc),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder(
      stream: _basePartsBloc.basePartsStream,
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
            onRefresh: () => _refreshBaseParts(),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshBaseParts(),
          child: _buildListView(baseParts),
        );
      },
    );
  }

  ListView _buildListView(List<BasePartModel> baseParts) {
    return ListView.separated(
        itemCount: baseParts.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(baseParts, i),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(List<BasePartModel> baseParts, int i) {
    return CustomListTile(
      title: 'id: ${baseParts[i].id}',
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => Navigator.pushNamed(context, 'basePartsDetail',
          arguments: baseParts[i]),
      subtitle:
          '${S.of(context).labelPlannedBaseLines} ${baseParts[i].plannedLinesBase}',
    );
  }

  Future<void> _refreshBaseParts() async =>
      await _basePartsBloc.getBaseParts(true, _programId);
}
