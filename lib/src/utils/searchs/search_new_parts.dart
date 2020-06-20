import 'package:flutter/cupertino.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/new_parts_bloc.dart';
import 'package:psp_admin/src/models/new_parts_model.dart';
import 'package:psp_admin/src/utils/searchs/search_delegate.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

class SearchNewParts extends DataSearch {
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
          return CustomListTile(
            title: newPart.name,
            onTap: () {
              close(context, null);
            },
            subtitle:
                '${S.of(context).labelPlannedLines} ${newPart.plannedLines}',
          );
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
