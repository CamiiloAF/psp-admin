import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/providers/models/fab_model.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/searchs/search_users.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';
import 'package:tuple/tuple.dart';

class UsersPage extends StatefulWidget {
  final int projectId;
  final bool isByOrganizationId;

  const UsersPage({@required this.projectId, this.isByOrganizationId = false});

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UsersBloc usersBloc;

  ScrollController controller = ScrollController();
  double lastScroll = 0;

  @override
  void initState() {
    controller.addListener(() {
      if (controller.offset > lastScroll && controller.offset > 150) {
        Provider.of<FabModel>(context, listen: false).isShowing = false;
      } else {
        Provider.of<FabModel>(context, listen: false).isShowing = true;
      }

      lastScroll = controller.offset;
    });

    super.initState();
    usersBloc = context.read<BlocProvider>().usersBloc;

    usersBloc.getUsers(false, widget.projectId, widget.isByOrganizationId);
  }

  @override
  void dispose() {
    super.dispose();
    if (!widget.isByOrganizationId) {
      usersBloc.dispose();
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShowing = Provider.of<FabModel>(context).isShowing;
    final usersBloc = Provider.of<BlocProvider>(context).usersBloc;

    Constants.token = Preferences().token;

    if (!isValidToken()) return NotAutorizedScreen();

    return ChangeNotifierProvider(
      create: (_) => FabModel(),
      child: Scaffold(
          appBar: (!widget.isByOrganizationId)
              ? null
              : CustomAppBar(
                  title: S.of(context).appBarTitleUsersByOrganization,
                  searchDelegate: SearchUsers(usersBloc),
                ),
          key: _scaffoldKey,
          body: _body(usersBloc),
          floatingActionButton: FAB(
            isShowing: isShowing,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    settings: RouteSettings(name: 'organizationUsers'),
                    builder: (context) => UsersPage(
                          projectId: widget.projectId,
                          isByOrganizationId: true,
                        ))),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat),
    );
  }

  Widget _body(UsersBloc usersBloc) {
    return StreamBuilder(
      stream: usersBloc.usersStream,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<int, List<UserModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          showSnackBar(context, _scaffoldKey.currentState, statusCode);
        }

        if (users.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshUsers(context, usersBloc),
            child: ListView(
              children: [
                Center(child: Text(S.of(context).thereIsNoInformation)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshUsers(context, usersBloc),
          child: _buildListView(users),
        );
      },
    );
  }

  ListView _buildListView(List<UserModel> users) {
    return ListView.builder(
      controller: controller,
      itemCount: users.length,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, i) => _buildItemList(users, i, context),
      //TODO - Ojo
      // separatorBuilder: (BuildContext context, int index) => Divider(
      //       thickness: 1.0,
      //     )
    );
  }

  Widget _buildItemList(List<UserModel> users, int i, BuildContext context) {
    final userFullName = users[i].firstName + users[i].lastName;
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direction) => (print('dismiss')),
      child: Column(
        children: [
          CustomListTile(
            title: userFullName,
            trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, 'editUser',
                      arguments: [users[i], widget.projectId]);
                }),
            onTap: () => {},
            subtitle: users[i].email,
          ),
          Divider()
        ],
      ),
    );
  }

  Future<void> _refreshUsers(BuildContext context, UsersBloc usersBloc) async {
    await usersBloc.getUsers(true, widget.projectId, widget.isByOrganizationId);
  }
}
