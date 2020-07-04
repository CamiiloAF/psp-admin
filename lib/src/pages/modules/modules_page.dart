import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/modules_bloc.dart';
import 'package:psp_admin/src/models/modules_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

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
        body: _body(_modulesBloc),
        floatingActionButton: FAB(
          routeName: 'editModule',
          arguments: [null, widget.projectId],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Widget _body(ModulesBloc modulesBloc) {
    return StreamBuilder(
      stream: modulesBloc.modulesStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<ModuleModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final modules = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (modules.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshModules(),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshModules(),
          child: _buildListView(modules),
        );
      },
    );
  }

  ListView _buildListView(List<ModuleModel> modules) {
    return ListView.separated(
        itemCount: modules.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(modules, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<ModuleModel> modules, int i, BuildContext context) {
    return CustomListTile(
      title: modules[i].name,
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, 'editModule',
                arguments: [modules[i], widget.projectId]);
          }),
      onTap: () =>
          Navigator.pushNamed(context, 'programs', arguments: modules[i].id),
      subtitle: modules[i].description,
    );
  }

  Future<void> _refreshModules() async =>
      await _modulesBloc.getModules(true, '${widget.projectId}');
}
