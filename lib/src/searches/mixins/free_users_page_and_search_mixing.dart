import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/pages/experiences/experiences_page.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';

mixin FreeUsersPageAndSearchMixing {
  UsersBloc _usersBloc;

  Widget buildItemList(BuildContext context, UserModel user,
      {Function closeSearch}) {
    final userFullName = '${user.firstName} ${user.lastName}';

    _usersBloc = Provider.of<BlocProvider>(context, listen: false).usersBloc;

    return CustomListTile(
      title: userFullName,
      onTap: () => _addUserIntoOrganization(context, user),
      onLongPress: () => _goToExperiences(context, user.id),
      subtitle: user.email,
    );
  }

  void _addUserIntoOrganization(BuildContext context, UserModel user) async {
    await _usersBloc.addUserIntoOrganization(user);

    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogSaving);

    await progressDialog.show();

    final statusCode = await _usersBloc.addUserIntoOrganization(user);

    await progressDialog.hide();
    onAddedUserIntoOrganization(statusCode);
  }

  void onAddedUserIntoOrganization(int statusCode);

  void _goToExperiences(BuildContext context, int userId) {
    Navigator.pushNamed(context, ExperiencesPage.ROUTE_NAME, arguments: userId);
  }
}
