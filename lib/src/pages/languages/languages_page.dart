import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/languages_bloc.dart';
import 'package:psp_admin/src/models/languages_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/searchs/mixins/language_page_and_search.dart';
import 'package:psp_admin/src/utils/searchs/search_languages.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_drawer_menu.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class LanguagesPage extends StatefulWidget {
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
    if (!isValidToken()) return NotAutorizedScreen();

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

  Widget _body() {
    return StreamBuilder(
      stream: _languagesBloc.languageStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<LanguageModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final languages = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (languages.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshLanguages(context),
            child: ListView(
              children: [
                Center(
                  child: Text(S.of(context).thereIsNoInformation),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshLanguages(context),
          child: _buildListView(languages),
        );
      },
    );
  }

  ListView _buildListView(List<LanguageModel> languages) {
    return ListView.separated(
        itemCount: languages.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => buildItemList(languages[i]),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }

  Future<void> _refreshLanguages(BuildContext context) async =>
      await _languagesBloc.getLanguages(true);
}
