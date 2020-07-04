import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/programs_bloc.dart';
import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/search_programs.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class ProgramsPage extends StatefulWidget {
  @override
  _ProgramsPageState createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ProgramsBloc _programsBloc;
  int _moduleId;

  @override
  void initState() {
    _programsBloc = context.read<BlocProvider>().programsBloc;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _moduleId = ModalRoute.of(context).settings.arguments;
    if (_programsBloc.lastValueProgramsController == null) {
      _programsBloc.getAllPrograms(false, _moduleId);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _programsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isValidToken()) return NotAutorizedScreen();

    final programsBloc = Provider.of<BlocProvider>(context).programsBloc;

    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          title: S.of(context).appBarTitlePrograms,
          searchDelegate: SearchPrograms(programsBloc),
        ),
        body: _body(programsBloc),
        floatingActionButton: FAB(
          routeName: 'createProgram',
          arguments: _moduleId,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
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
            onRefresh: () => _refreshPrograms(),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshPrograms(),
          child: _buildListView(programs),
        );
      },
    );
  }

  ListView _buildListView(List<ProgramModel> programs) {
    return ListView.separated(
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
                arguments: [programs[i], _moduleId]);
          }),
      onTap: () =>
          Navigator.pushNamed(context, 'programItems', arguments: programs[i]),
      subtitle: programs[i].description,
    );
  }

  Future<void> _refreshPrograms() async =>
      await _programsBloc.getAllPrograms(true, _moduleId);
}
