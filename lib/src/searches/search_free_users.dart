import 'package:flutter/cupertino.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/searches/mixins/free_users_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_delegate.dart';

class SearchFreeUsers extends DataSearch with FreeUsersPageAndSearchMixing {
  final UsersBloc _usersBloc;

  BuildContext _context;

  SearchFreeUsers(this._usersBloc);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    _context = context;

    final users = _usersBloc.lastValueFreeUsersController?.item2;

    if (users.isNotEmpty && users != null) {
      return Container(
          child: ListView(
        children: users
            .where((user) => _areItemContainQuery(user, query))
            .map((user) {
          return buildItemList(context, user);
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  bool _areItemContainQuery(UserModel user, String query) {
    return user.firstName.toLowerCase().contains(query.toLowerCase()) ||
            user.lastName.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase())
        ? true
        : false;
  }

  @override
  void onAddedUserIntoOrganization(int statusCode) =>
      close(_context, statusCode);
}
