import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/pages/modules/modules_page.dart';
import 'package:psp_admin/src/pages/users/users_page.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/providers/models/tab_model.dart';
import 'package:psp_admin/src/searches/search_modules.dart';
import 'package:psp_admin/src/searches/search_users.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class ProjectItemsPage extends StatefulWidget {
  @override
  _ProjectItemsPageState createState() => _ProjectItemsPageState();
}

class _ProjectItemsPageState extends State<ProjectItemsPage> {
  BlocProvider _blocProvider;

  @override
  void initState() {
    _blocProvider = context.read<BlocProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _blocProvider..usersBloc.dispose()..modulesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isValidToken()) return NotAutorizedScreen();
    final int projectId = ModalRoute.of(context).settings.arguments;

    final usersSearchDelegate = SearchUsers(
      _blocProvider.usersBloc,
      projectId,
      isByOrganizationId: false,
    );

    final modulesSearchDelegate =
        SearchModules(_blocProvider.modulesBloc, projectId);

    return ChangeNotifierProvider(
      create: (context) => TabModel(),
      builder: (ctx, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppBar(
            searchDelegate: Provider.of<TabModel>(ctx).searchDelegate ??
                usersSearchDelegate,
            bottom: TabBar(
              onTap: (value) => Provider.of<TabModel>(ctx, listen: false)
                      .searchDelegate =
                  (value == 0) ? usersSearchDelegate : modulesSearchDelegate,
              indicatorColor: Theme.of(context).accentColor,
              tabs: [
                Tab(
                  text: S.of(context).appBarTitleUsers,
                ),
                Tab(
                  text: S.of(context).appBarTitleModules,
                ),
              ],
            ),
            title: S.of(context).appBarTitleProjectItems,
          ),
          body: TabBarView(
            children: [
              UsersPage(projectId: projectId),
              ModulesPage(projectId: projectId),
            ],
          ),
        ),
      ),
    );
  }
}
