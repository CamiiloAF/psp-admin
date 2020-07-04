import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/programs_bloc.dart';
import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/search_programs.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

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

    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          title: S.of(context).appBarTitlePrograms,
          searchDelegate: SearchPrograms(_programsBloc),
        ),
        body: _body(),
        floatingActionButton: FAB(
          routeName: 'createProgram',
          arguments: _moduleId,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Widget _body() => CommonListOfModels(
        stream: _programsBloc.programsStream,
        onRefresh: _onRefreshPrograms,
        scaffoldState: _scaffoldKey.currentState,
        buildItemList: (items, index) => _buildItemList(items[index]),
      );

  Widget _buildItemList(ProgramModel program) {
    return CustomListTile(
      title: program.name,
      trailing: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            Navigator.pushNamed(context, '', arguments: [program, _moduleId]);
          }),
      onTap: () =>
          Navigator.pushNamed(context, 'programItems', arguments: program),
      subtitle: program.description,
    );
  }

  Future<void> _onRefreshPrograms() async =>
      await _programsBloc.getAllPrograms(true, _moduleId);
}
