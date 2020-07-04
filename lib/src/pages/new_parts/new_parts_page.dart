import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/new_parts_bloc.dart';
import 'package:psp_admin/src/models/new_parts_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/search_new_parts.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class NewPartsPage extends StatefulWidget {
  @override
  _NewPartsPageState createState() => _NewPartsPageState();
}

class _NewPartsPageState extends State<NewPartsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  NewPartsBloc _newPartsBloc;
  int _programId;

  @override
  void initState() {
    _newPartsBloc = context.read<BlocProvider>().newPartsBloc;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _programId = ModalRoute.of(context).settings.arguments;
    if (_newPartsBloc.lastValueNewPartsController == null) {
      _newPartsBloc.getNewParts(false, _programId);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _newPartsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isValidToken()) return NotAutorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: S.of(context).appBarTitleNewParts,
        searchDelegate: SearchNewParts(_newPartsBloc),
      ),
      body: _body(),
    );
  }

  Widget _body() => CommonListOfModels(
        stream: _newPartsBloc.newPartsStream,
        onRefresh: _onRefreshNewParts,
        scaffoldState: _scaffoldKey.currentState,
        buildItemList: (items, index) => _buildItemList(items[index]),
      );

  Widget _buildItemList(NewPartModel newPart) {
    return CustomListTile(
      title: newPart.name,
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () =>
          Navigator.pushNamed(context, 'newPartsDetail', arguments: newPart),
      subtitle: '${S.of(context).labelPlannedLines} ${newPart.plannedLines}',
    );
  }

  Future<void> _onRefreshNewParts() async =>
      await _newPartsBloc.getNewParts(true, _programId);
}
