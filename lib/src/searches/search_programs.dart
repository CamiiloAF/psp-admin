import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/src/blocs/programs_bloc.dart';
import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/searches/mixins/programs_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_delegate.dart';

class SearchPrograms extends DataSearch with ProgramsPageAndSearchMixing {
  final ProgramsBloc _programsBloc;
  final int _moduleId;

  SearchPrograms(this._programsBloc, this._moduleId);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    final programs = _programsBloc?.lastValueProgramsController?.item2 ?? [];
    if (programs.isNotEmpty && programs != null) {
      return Container(
          child: ListView(
        children: programs
            .where((program) => _areItemContainQuery(program, query))
            .map((program) {
          return buildItemList(context, program, _moduleId,
              closeSearch: () => close(context, null));
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(ProgramModel program, String query) {
    return program.name.toLowerCase().contains(query.toLowerCase()) ||
            program.description.toLowerCase().contains(query.toLowerCase())
        ? true
        : false;
  }
}
