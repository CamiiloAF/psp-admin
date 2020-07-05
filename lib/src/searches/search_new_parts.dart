import 'package:flutter/cupertino.dart';
import 'package:psp_admin/src/blocs/new_parts_bloc.dart';
import 'package:psp_admin/src/models/new_parts_model.dart';
import 'package:psp_admin/src/searches/mixins/new_parts_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_delegate.dart';

class SearchNewParts extends DataSearch with NewPartsPageAndSearchMixing {
  final NewPartsBloc _newPartsBloc;

  SearchNewParts(this._newPartsBloc);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    final newParts = _newPartsBloc?.lastValueNewPartsController?.item2 ?? [];
    if (newParts.isNotEmpty && newParts != null) {
      return Container(
          child: ListView(
        children: newParts
            .where((newPart) => _areItemContainQuery(newPart, query))
            .map((newPart) {
          return buildItemList(context, newPart,
              closeSearch: () => close(context, null));
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(NewPartModel newPart, String query) {
    return newPart.name.toLowerCase().contains(query.toLowerCase()) ||
            '${newPart.plannedLines}'
                .toLowerCase()
                .contains(query.toLowerCase())
        ? true
        : false;
  }
}
