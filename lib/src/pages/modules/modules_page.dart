import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/modules_bloc.dart';
import 'package:psp_admin/src/models/modules_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/providers/models/fab_model.dart';
import 'package:psp_admin/src/providers/models/tab_model.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/searchs/search_modules.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class ModulesPage extends StatefulWidget {
  final String projectId;

  const ModulesPage({@required this.projectId});

  @override
  _ModulesPageState createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ModulesBloc modulesBloc;

  ScrollController controller = ScrollController();
  double lastScroll = 0;

  @override
  void initState() {
    controller.addListener(() {
      if (controller.offset > lastScroll && controller.offset > 150) {
        Provider.of<FabModel>(context, listen: false).isShowing = false;
      } else {
        Provider.of<FabModel>(context, listen: false).isShowing = true;
      }

      lastScroll = controller.offset;
    });

    super.initState();
    modulesBloc = context.read<BlocProvider>().modulesBloc;

    modulesBloc.getModules(false, widget.projectId);
  }

  @override
  void dispose() {
    super.dispose();
    modulesBloc.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShowing = Provider.of<FabModel>(context).isShowing;
    final modulesBloc = Provider.of<BlocProvider>(context).modulesBloc;

    Constants.token = Preferences().token;

    if (!isValidToken()) return NotAutorizedScreen();

    return ChangeNotifierProvider(
      create: (_) => FabModel(),
      child: Scaffold(
          key: _scaffoldKey,
          // appBar: CustomAppBar(
          //     title: S.of(context).appBarTitleModules,
          //     searchDelegate:
          //         ModulesSearch(modulesBloc, int.parse(widget.projectId))),
          body: _body(modulesBloc),
          floatingActionButton: FAB(
            isShowing: isShowing,
            routeName: 'editModule',
            arguments: [null, int.parse(widget.projectId)],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat),
    );
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
            onRefresh: () => _refreshModules(context, modulesBloc),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshModules(context, modulesBloc),
          child: _buildListView(modules.reversed.toList()),
        );
      },
    );
  }

  ListView _buildListView(List<ModuleModel> modules) {
    return ListView.separated(
        controller: controller,
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
                arguments: [modules[i], int.parse(widget.projectId)]);
          }),
      onTap: () => {},
      subtitle: modules[i].description,
    );
  }

  Future<void> _refreshModules(
      BuildContext context, ModulesBloc modulesBloc) async {
    await modulesBloc.getModules(true, widget.projectId);
  }
}
