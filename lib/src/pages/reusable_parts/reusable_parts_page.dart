import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/reusable_parts_bloc.dart';
import 'package:psp_admin/src/models/reusable_parts_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/search_reusable_parts.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class ReusablePartsPage extends StatefulWidget {
  @override
  _ReusablePartsPageState createState() => _ReusablePartsPageState();
}

class _ReusablePartsPageState extends State<ReusablePartsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ReusablePartsBloc _reusablePartsBloc;
  int _programId;

  @override
  void initState() {
    _reusablePartsBloc = context.read<BlocProvider>().reusablePartsBloc;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _programId = ModalRoute.of(context).settings.arguments;
    if (_reusablePartsBloc.lastValueReusablePartsController == null) {
      _reusablePartsBloc.getReusableParts(false, _programId);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _reusablePartsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isValidToken()) return NotAutorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: S.of(context).appBarTitleReusableParts,
        searchDelegate: SearchReusableParts(_reusablePartsBloc),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder(
      stream: _reusablePartsBloc.reusablePartsStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<ReusablePartModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final reusableParts = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (reusableParts.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshReusableParts(),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshReusableParts(),
          child: _buildListView(reusableParts),
        );
      },
    );
  }

  ListView _buildListView(List<ReusablePartModel> reusableParts) {
    return ListView.separated(
        itemCount: reusableParts.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(reusableParts, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<ReusablePartModel> reusableParts, int i, BuildContext context) {
    return CustomListTile(
      title:
          '${S.of(context).labelPlannedLines} ${reusableParts[i].plannedLines}',
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => {
        Navigator.pushNamed(context, 'reusablePartsDetail',
            arguments: reusableParts[i])
      },
    );
  }

  Future<void> _refreshReusableParts() async =>
      await _reusablePartsBloc.getReusableParts(true, _programId);
}
