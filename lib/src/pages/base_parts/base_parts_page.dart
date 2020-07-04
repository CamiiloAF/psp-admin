import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/base_parts_bloc.dart';
import 'package:psp_admin/src/models/base_parts_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/search_base_parts.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

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

  Widget _body() => CommonListOfModels(
        stream: _basePartsBloc.basePartsStream,
        onRefresh: _onRefreshBaseParts,
        scaffoldState: _scaffoldKey.currentState,
        buildItemList: (items, index) => _buildItemList(items[index]),
      );

  Widget _buildItemList(BasePartModel basePart) {
    return CustomListTile(
      title: 'id: ${basePart.id}',
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () =>
          Navigator.pushNamed(context, 'basePartsDetail', arguments: basePart),
      subtitle:
          '${S.of(context).labelPlannedBaseLines} ${basePart.plannedLinesBase}',
    );
  }

  Future<void> _onRefreshBaseParts() async =>
      await _basePartsBloc.getBaseParts(true, _programId);
}
