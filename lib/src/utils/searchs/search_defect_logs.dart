import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/src/blocs/defect_logs_bloc.dart';
import 'package:psp_admin/src/models/defect_logs_model.dart';
import 'package:psp_admin/src/utils/searchs/search_delegate.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

class SearchDefectLogs extends DataSearch {
  final DefectLogsBloc _defectLogsBloc;

  SearchDefectLogs(this._defectLogsBloc);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    final defectLogs =
        _defectLogsBloc?.lastValueDefectLogsController?.item2 ?? [];
    if (defectLogs.isNotEmpty && defectLogs != null) {
      return Container(
          child: ListView(
        children: defectLogs
            .where((defectLog) => _areItemContainQuery(defectLog, query))
            .map((defectLog) {
          return CustomListTile(
            title: 'id: ${defectLog.id}',
            onTap: () {
              close(context, null);
            },
            subtitle: defectLog.description,
          );
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(DefectLogModel defectLog, String query) {
    return '${defectLog.id}'.contains(query.toLowerCase()) ||
            defectLog.description.toLowerCase().contains(query.toLowerCase())
        ? true
        : false;
  }
}
