import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/pages/users/users_edit_page.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/searches/mixins/users_page_and_search_mixing.dart';
import 'package:psp_admin/src/searches/search_users.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/common_list_of_models.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';

class UsersPage extends StatefulWidget {
  final int projectId;
  final bool isByOrganizationId;

  UsersPage({@required this.projectId, this.isByOrganizationId = false});

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with UsersPageAndSearchMixing {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UsersBloc _usersBloc;

  @override
  void initState() {
    _usersBloc = context.read<BlocProvider>().usersBloc;
    _usersBloc.getUsers(false, widget.projectId, widget.isByOrganizationId);

    initializeMixing(context, widget.projectId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (!widget.isByOrganizationId)
            ? null
            : CustomAppBar(
                title: S.of(context).appBarTitleUsersByOrganization,
                searchDelegate: SearchUsers(
                  _usersBloc,
                  widget.projectId,
                  isByOrganizationId: widget.isByOrganizationId,
                ),
                onThenShowSearch: onThenShowSearch,
              ),
        key: _scaffoldKey,
        body: _body(_usersBloc),
        floatingActionButton: FAB(onPressed: _onPressedFab),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  void _onPressedFab() {
    if (widget.isByOrganizationId) {
      Navigator.pushNamed(context, UserEditPage.ROUTE_NAME,
          arguments: [null, widget.projectId]);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              settings: RouteSettings(name: 'organization-users'),
              builder: (context) => UsersPage(
                    projectId: widget.projectId,
                    isByOrganizationId: true,
                  )));
    }
  }

  Widget _body(UsersBloc usersBloc) => CommonListOfModels(
      stream: (widget.isByOrganizationId)
          ? usersBloc.usersByOrganizationStream
          : usersBloc.usersByProjectIdStream,
      onRefresh: _onRefreshUsers,
      scaffoldKey: _scaffoldKey,
      buildItemList: (items, index) => _buildItemList(items, index));

  Widget _buildItemList(List<UserModel> users, int i) {
    final user = users[i];
    var isUserInUsersByProjects = false;

    if (widget.isByOrganizationId) {
      isUserInUsersByProjects = _usersBloc.isUserInProject(user);
    }

    final customListTile = buildSingleItemList(user, isUserInUsersByProjects,
        () => {if (widget.isByOrganizationId) addUserToProject(user)});

    return (widget.isByOrganizationId || _usersBloc.isCurrentUser(user))
        ? customListTile
        : _buildDismissible(user, users, customListTile);
  }

  Dismissible _buildDismissible(
      UserModel user, List<UserModel> users, Widget customListTile) {
    return Dismissible(
        direction: DismissDirection.startToEnd,
        key: Key('${user.id}'),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 32,
                  )),
              Spacer()
            ],
          ),
        ),
        onDismissed: (direction) {
          _usersBloc.removeUserFromProject(widget.projectId, user);
          setState(() {
            users.remove(user);
          });
        },
        child: customListTile);
  }

  @override
  void onAddedUserToProject(int statusCode) {
    if (statusCode == 201) {
      setState(() {});
    } else {
      showSnackBar(context, _scaffoldKey.currentState, statusCode);
    }
  }

  void onThenShowSearch(int statusCode) =>
      (statusCode == null) ? null : onAddedUserToProject(statusCode);

  Future<void> _onRefreshUsers() async {
    await _usersBloc.getUsers(
        true, widget.projectId, widget.isByOrganizationId);
  }
}
