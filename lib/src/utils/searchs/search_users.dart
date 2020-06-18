import 'package:flutter/cupertino.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/utils/searchs/search_delegate.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

class SearchUsers extends DataSearch {
  final UsersBloc _usersBloc;
  final bool isByOrganizationId;

  SearchUsers(this._usersBloc, {@required this.isByOrganizationId});

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return super.textNoResults(context);

    final users = (isByOrganizationId)
        ? _usersBloc?.lastValueUsersByOrganizationController?.item2 ?? []
        : _usersBloc?.lastValueUsersByProjectController?.item2 ?? [];

    if (users.isNotEmpty && users != null) {
      return Container(
          child: ListView(
        children: users
            .where((user) => _areItemContainQuery(user, query))
            .map((user) {
          return CustomListTile(
            title: user.firstName + user.lastName,
            onTap: () => close(context, null),
            subtitle: user.email,
          );
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
}
