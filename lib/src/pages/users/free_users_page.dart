import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/searches/mixins/free_users_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_free_users.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_drawer_menu.dart';

class FreeUsersPage extends StatefulWidget {
  static const ROUTE_NAME = 'free-users';

  @override
  _FreeUsersPageState createState() => _FreeUsersPageState();
}

class _FreeUsersPageState extends State<FreeUsersPage>
    with FreeUsersPageAndSearchMixing {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UsersBloc _usersBloc;

  @override
  void initState() {
    _usersBloc = context.read<BlocProvider>().usersBloc;
    _usersBloc.getFreeUsers();

    super.initState();
  }

  @override
  void dispose() {
    _usersBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: S.of(context).appBarTitleFreeUsers,
        searchDelegate: SearchFreeUsers(_usersBloc),
        onThenShowSearch: onThenShowSearch,
      ),
      drawer: CustomDrawerMenu(),
      body: _body(_usersBloc),
    );
  }

  Widget _body(UsersBloc _usersBloc) => CommonListOfModels(
      stream: _usersBloc.freeUsersStream,
      onRefresh: _onRefreshUsers,
      scaffoldKey: _scaffoldKey,
      buildItemList: (items, index) => buildItemList(context, items[index]));

  void onThenShowSearch(int statusCode) =>
      (statusCode != null) ? onAddedUserIntoOrganization(statusCode) : null;

  Future<void> _onRefreshUsers() async => await _usersBloc.getFreeUsers();

  @override
  void onAddedUserIntoOrganization(int statusCode) {
    if (statusCode == 204) {
      setState(() {});
    } else {
      showSnackBar(context, _scaffoldKey.currentState, statusCode);
    }
  }
}
