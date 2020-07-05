import 'package:flutter/cupertino.dart';
import 'package:psp_admin/src/blocs/reusable_parts_bloc.dart';
import 'package:psp_admin/src/models/reusable_parts_model.dart';
import 'package:psp_admin/src/searches/mixins/reusable_parts_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_delegate.dart';

class SearchReusableParts extends DataSearch
    with ReusablePartsPageAndSearchMixing {
  final ReusablePartsBloc _reusablePartsBloc;

  SearchReusableParts(this._reusablePartsBloc);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    final reusableParts =
        _reusablePartsBloc?.lastValueReusablePartsController?.item2 ?? [];

    if (reusableParts.isNotEmpty && reusableParts != null) {
      return Container(
          child: ListView(
        children: reusableParts
            .where((reusablePart) => _areItemContainQuery(reusablePart, query))
            .map((reusablePart) {
          return buildItemList(context, reusablePart,
              closeSearch: () => close(context, null));
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(ReusablePartModel reusablePart, String query) {
    return '${reusablePart.plannedLines}'.contains(query.toLowerCase())
        ? true
        : false;
  }
}
