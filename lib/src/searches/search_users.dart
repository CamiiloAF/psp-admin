import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/searches/mixins/users_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_delegate.dart';

class SearchUsers extends DataSearch with UsersPageAndSearchMixing {
  final UsersBloc _usersBloc;
  final bool isByOrganizationId;
  final int _projectId;

  BuildContext _context;

  SearchUsers(this._usersBloc, this._projectId,
      {@required this.isByOrganizationId});

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    _context = context;
    initializeMixing(context, _projectId);

    final users = (isByOrganizationId)
        ? _usersBloc?.lastValueUsersByOrganizationController?.item2 ?? []
        : _usersBloc?.lastValueUsersByProjectController?.item2 ?? [];

    if (users.isNotEmpty && users != null) {
      return Container(
          child: ListView(
        children: users
            .where((user) => _areItemContainQuery(user, query))
            .map((user) {
          return buildSingleItemList(
              user, isUserInUsersByProjects(user), () => onTapItem(user));
        }).toList(),
      ));
    } else {
      return super.textNoResults(context);
    }
  }

  void onTapItem(UserModel user) =>
      {if (isByOrganizationId) addUserToProject(user)};

  bool _areItemContainQuery(UserModel user, String query) {
    return user.firstName.toLowerCase().contains(query.toLowerCase()) ||
            user.lastName.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase())
        ? true
        : false;
  }

  @override
  void onAddedUserToProject(int statusCode) => close(_context, statusCode);

  bool isUserInUsersByProjects(UserModel user) {
    if (!isByOrganizationId) return false;

    final usersBloc =
        Provider.of<BlocProvider>(_context, listen: false).usersBloc;

    return usersBloc.isUserInProject(user);
  }
}
