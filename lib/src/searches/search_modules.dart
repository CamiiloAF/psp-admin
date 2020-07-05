import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/src/blocs/modules_bloc.dart';
import 'package:psp_admin/src/models/modules_model.dart';
import 'package:psp_admin/src/searches/mixins/modules_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_delegate.dart';

class SearchModules extends DataSearch with ModulesPageAndSearchMixing {
  final ModulesBloc _modulesBloc;
  final int _projectId;

  SearchModules(this._modulesBloc, this._projectId);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    final modules = _modulesBloc?.lastValueModulesController?.item2 ?? [];
    if (modules.isNotEmpty && modules != null) {
      return Container(
          child: ListView(
        children: modules
            .where((module) => _areItemContainQuery(module, query))
            .map((module) {
          return buildItemList(context, module, _projectId,
              closeSearch: () => close(context, null));
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(ModuleModel module, String query) {
    return module.projectsId == _projectId &&
                module.name.toLowerCase().contains(query.toLowerCase()) ||
            module.description.toLowerCase().contains(query.toLowerCase())
        ? true
        : false;
  }
}
