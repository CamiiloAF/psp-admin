import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/pages/modules/modules_page.dart';
import 'package:psp_admin/src/pages/users/users_page.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/providers/models/tab_model.dart';
import 'package:psp_admin/src/searches/search_modules.dart';
import 'package:psp_admin/src/searches/search_users.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';

class ProjectItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int projectId = ModalRoute.of(context).settings.arguments;

    final blocProvider = Provider.of<BlocProvider>(context);

    final usersSearchDelegate = SearchUsers(
      blocProvider.usersBloc,
      projectId,
      isByOrganizationId: false,
    );

    final modulesSearchDelegate =
        SearchModules(blocProvider.modulesBloc, projectId);

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
