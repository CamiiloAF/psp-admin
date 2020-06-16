import 'package:flutter/material.dart';
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
            tabs: [
              Tab(
                text: 'Modulos',
              ),
              Tab(
                text: 'Usuarios',
              ),
            ],
          ),
          title: 'Tabs Demo',
        ),
        body: TabBarView(
          children: [
            ModulesPage(projectId: '$projectId'),
            UsersPage(projectId: projectId),
          ],
        ),
      ),
    );
  }
}
