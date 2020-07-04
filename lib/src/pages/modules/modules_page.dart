import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/src/blocs/modules_bloc.dart';
import 'package:psp_admin/src/models/modules_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class ModulesPage extends StatefulWidget {
  final int projectId;

  const ModulesPage({this.projectId});

  @override
  _ModulesPageState createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ModulesBloc _modulesBloc;

  @override
  void initState() {
    _modulesBloc = context.read<BlocProvider>().modulesBloc;
    _modulesBloc.getModules(false, '${widget.projectId}');
    super.initState();
  }

  @override
  void dispose() {
    _modulesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isValidToken()) return NotAutorizedScreen();

    return Scaffold(
        key: _scaffoldKey,
        body: _body(),
        floatingActionButton: FAB(
          routeName: 'editModule',
          arguments: [null, widget.projectId],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Widget _body() => CommonListOfModels(
        stream: _modulesBloc.modulesStream,
        onRefresh: _onRefreshModules,
        scaffoldState: _scaffoldKey.currentState,
        buildItemList: (items, index) => _buildItemList(items[index]),
      );

  Widget _buildItemList(ModuleModel module) {
    return CustomListTile(
      title: module.name,
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.pushNamed(context, 'editModule',
              arguments: [module, widget.projectId])),
      onTap: () =>
          Navigator.pushNamed(context, 'programs', arguments: module.id),
      subtitle: module.description,
    );
  }

  Future<void> _onRefreshModules() async =>
      await _modulesBloc.getModules(true, '${widget.projectId}');
}