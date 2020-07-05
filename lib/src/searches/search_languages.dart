import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/src/blocs/languages_bloc.dart';
import 'package:psp_admin/src/models/languages_model.dart';
import 'package:psp_admin/src/searches/search_delegate.dart';

import 'mixins/languages_page_and_search_mixing.dart';

class SearchLanguages extends DataSearch with LanguagePageAndSearchMixing {
  final LanguagesBloc languagesBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;

  SearchLanguages({this.languagesBloc, this.scaffoldKey});

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);
    initializeMixing(context, scaffoldKey);

    final languages = languagesBloc?.lastValueLanguagesController?.item2 ?? [];
    if (languages.isNotEmpty && languages != null) {
      return Container(
          child: ListView(
        children: languages
            .where((language) => _areItemContainQuery(language, query))
            .map((language) {
          return buildItemList(language);
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(LanguageModel language, String query) =>
      language.name.toLowerCase().contains(query.toLowerCase());
}
