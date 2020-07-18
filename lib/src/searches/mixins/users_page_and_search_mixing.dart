import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/pages/analysis_tools/analysis_tools_page.dart';
import 'package:psp_admin/src/pages/experiences/experiences_page.dart';
import 'package:psp_admin/src/pages/users/users_edit_page.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin UsersPageAndSearchMixing {
  BuildContext _context;
  int _projectId;

  UsersBloc _usersBloc;
  Function onCloseSearch;

  void initializeMixing(BuildContext context, int projectId) {
    _context = context;
    _projectId = projectId;

    _usersBloc = Provider.of<BlocProvider>(context, listen: false).usersBloc;
  }

  Widget buildSingleItemList(
      UserModel user, bool isUserInUsersByProjects, Function onTapItem) {
    final userFullName = '${user.firstName} ${user.lastName}';

    return CustomListTile(
      title: userFullName,
      isEnable: user.organizationsId != null && !isUserInUsersByProjects,
      trailing: Container(
        width: MediaQuery.of(_context).size.width * 0.28,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                icon: Icon(Icons.show_chart),
                onPressed: () {
                  Navigator.pushNamed(_context, AnalysisToolsPage.ROUTE_NAME);
                }),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(_context, UserEditPage.ROUTE_NAME,
                      arguments: [user, _projectId]);
                }),
          ],
        ),
      ),
      onTap: onTapItem,
      onLongPress: () => _goToExperiences(user.id),
      subtitle: user.email,
    );
  }

  void onAddedUserToProject(int statusCode);

  void addUserToProject(UserModel user) async {
    final progressDialog =
        getProgressDialog(_context, S.of(_context).progressDialogSaving);

    await progressDialog.show();

    final statusCode = await _usersBloc.addUserToProject(_projectId, user);

    await progressDialog.hide();
    onAddedUserToProject(statusCode);
  }

  void _goToExperiences(int userId) {
    Navigator.pushNamed(_context, ExperiencesPage.ROUTE_NAME,
        arguments: userId);
  }
}
