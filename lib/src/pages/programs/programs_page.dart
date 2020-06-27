import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/programs_bloc.dart';
import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/providers/models/fab_model.dart';
import 'package:psp_admin/src/utils/searchs/search_programs.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class ProgramsPage extends StatefulWidget {
  final int moduleId;

  const ProgramsPage({@required this.moduleId});

  @override
  _ProgramsPageState createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgramsBloc programsBloc;

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
    programsBloc = context.read<BlocProvider>().programsBloc;
    programsBloc.getAllPrograms(false, widget.moduleId);
  }

  @override
  void dispose() {
    super.dispose();
    programsBloc.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShowing = Provider.of<FabModel>(context).isShowing;
    final programsBloc = Provider.of<BlocProvider>(context).programsBloc;

    if (!isValidToken()) return NotAutorizedScreen();

    return ChangeNotifierProvider(
      create: (_) => FabModel(),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            title: S.of(context).appBarTitlePrograms,
            searchDelegate: SearchPrograms(programsBloc),
          ),
          body: _body(programsBloc),
          floatingActionButton: FAB(
            isShowing: isShowing,
            routeName: 'createProgram',
            arguments: widget.moduleId,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat),
    );
  }

  Widget _body(ProgramsBloc programsBloc) {
    return StreamBuilder(
      stream: programsBloc.programsStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<ProgramModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final programs = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (programs.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshPrograms(context, programsBloc),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshPrograms(context, programsBloc),
          child: _buildListView(programs),
        );
      },
    );
  }

  ListView _buildListView(List<ProgramModel> programs) {
    return ListView.separated(
        controller: controller,
        itemCount: programs.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => _buildItemList(programs, i, context),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Widget _buildItemList(
      List<ProgramModel> programs, int i, BuildContext context) {
    return CustomListTile(
      title: programs[i].name,
      trailing: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            Navigator.pushNamed(context, '',
                arguments: [programs[i], widget.moduleId]);
          }),
      onTap: () => {
        Navigator.pushNamed(context, 'programItems', arguments: programs[i])
      },
      subtitle: programs[i].description,
    );
  }

  Future<void> _refreshPrograms(
      BuildContext context, ProgramsBloc programsBloc) async {
    await programsBloc.getAllPrograms(true, widget.moduleId);
  }
}
