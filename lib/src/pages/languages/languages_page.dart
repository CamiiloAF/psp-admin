import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/languages_bloc.dart';
import 'package:psp_admin/src/models/languages_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/searches/mixins/languages_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_languages.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_drawer_menu.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';

class LanguagesPage extends StatefulWidget {
  static const ROUTE_NAME = 'languages';

  @override
  _LanguagesPageState createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage>
    with LanguagePageAndSearchMixing {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LanguagesBloc _languagesBloc;

  @override
  void initState() {
    _languagesBloc = context.read<BlocProvider>().languagesBloc;
    _languagesBloc.getLanguages(false);

    super.initState();
  }

  @override
  void dispose() {
    _languagesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();

    initializeMixing(context, _scaffoldKey);

    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
            title: S.of(context).appBarTitleLanguages,
            searchDelegate: SearchLanguages(
                languagesBloc: _languagesBloc, scaffoldKey: _scaffoldKey)),
        body: _body(),
        floatingActionButton: FAB(
          onPressed: () => showDialogEditLanguage(LanguageModel()),
        ),
        drawer: CustomDrawerMenu(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Widget _body() => CommonListOfModels(
        stream: _languagesBloc.languagesStream,
        onRefresh: _onRefreshTimeLogs,
        scaffoldKey: _scaffoldKey,
        buildItemList: (items, index) => buildItemList(items[index]),
      );

  Future<void> _onRefreshTimeLogs() async =>
      await _languagesBloc.getLanguages(true);
}
