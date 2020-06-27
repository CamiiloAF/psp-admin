import 'package:flutter/cupertino.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/base_parts_bloc.dart';
import 'package:psp_admin/src/models/base_parts_model.dart';
import 'package:psp_admin/src/utils/searchs/search_delegate.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

class SearchBaseParts extends DataSearch {
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
          return CustomListTile(
            title: 'id: ${basePart.id}',
            onTap: () {
              close(context, null);
              Navigator.pushNamed(context, 'basePartsDetail',
                  arguments: basePart);
            },
            subtitle:
                '${S.of(context).labelPlannedBaseLines} ${basePart.plannedLinesBase}',
          );
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(BasePartModel basePart, String query) {
    return '${basePart.id}'.contains(query.toLowerCase()) ||
            '${basePart.plannedLinesAdded}'
                .toLowerCase()
                .contains(query.toLowerCase())
        ? true
        : false;
  }
}
