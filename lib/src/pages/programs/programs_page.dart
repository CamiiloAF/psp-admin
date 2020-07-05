import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/programs_bloc.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/searches/mixins/programs_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_programs.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class ProgramsPage extends StatefulWidget {
  @override
  _ProgramsPageState createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage>
    with ProgramsPageAndSearchMixing {
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
          searchDelegate: SearchPrograms(_programsBloc, _moduleId),
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
        scaffoldKey: _scaffoldKey,
        buildItemList: (items, index) =>
            buildItemList(context, items[index], _moduleId),
      );

  Future<void> _onRefreshPrograms() async =>
      await _programsBloc.getAllPrograms(true, _moduleId);
}
