import 'package:flutter/cupertino.dart';
import 'package:psp_admin/src/blocs/base_parts_bloc.dart';
import 'package:psp_admin/src/models/base_parts_model.dart';
import 'package:psp_admin/src/searches/mixins/base_parts_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_delegate.dart';

class SearchBaseParts extends DataSearch with BasePartsPageAndSearchMixing {
  final BasePartsBloc _basePartsBloc;

  SearchBaseParts(this._basePartsBloc);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    final baseParts = _basePartsBloc?.lastValueBasePartsController?.item2 ?? [];
    if (baseParts.isNotEmpty && baseParts != null) {
      return Container(
          child: ListView(
        children: baseParts
            .where((basePart) => _areItemContainQuery(basePart, query))
            .map((basePart) {
          return buildItemList(context, basePart,
              closeSearch: () => close(context, null));
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(BasePartModel basePart, String query) {
    return '${basePart.plannedLinesBase}'
                .contains(query.toLowerCase()) ||
            basePart.currentLinesBase != null &&
                '${basePart.currentLinesBase}'
                    .contains(query.toLowerCase())
        ? true
        : false;
  }
}
