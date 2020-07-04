import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/pages/modules/modules_page.dart';
import 'package:psp_admin/src/pages/users/users_page.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';

class ProjectItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int projectId = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          bottom: TabBar(
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
    );
  }
}
