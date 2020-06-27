import 'package:flutter/cupertino.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/reusable_parts_bloc.dart';
import 'package:psp_admin/src/models/reusable_parts_model.dart';
import 'package:psp_admin/src/utils/searchs/search_delegate.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

class SearchReusableParts extends DataSearch {
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
          return CustomListTile(
            title:
                '${S.of(context).labelPlannedLines} ${reusablePart.plannedLines}',
            onTap: () {
              close(context, null);
              Navigator.pushNamed(context, 'reusablePartsDetail',
                  arguments: reusablePart);
            },
          );
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
