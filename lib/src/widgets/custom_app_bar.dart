import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/providers/session_provider.dart';
import 'package:psp_admin/src/utils/utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SearchDelegate searchDelegate;

  final _sessionProvider = SessionProvider();

  final _optionSettingsIndex = 0;
  final _optionLogOutIndex = 1;

  CustomAppBar({this.searchDelegate});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).appBarTitleProjects),
      actions: appBarActions(context),
    );
  }

  List<Widget> appBarActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: searchDelegate);
          }),
      PopupMenuButton(
          onSelected: (value) => onItemMenuSelected(value, context),
          itemBuilder: (context) => getPopUpMenuOptions(context)
              .map((option) =>
                  PopupMenuItem<String>(value: option, child: Text(option)))
              .toList())
    ];
  }

  List<String> getPopUpMenuOptions(BuildContext context) => [
        S.of(context).optionSettings,
        S.of(context).optionLogOut,
      ];

  void onItemMenuSelected(String value, BuildContext context) {
    final options = getPopUpMenuOptions(context);

    if (value == options[_optionSettingsIndex]) {
    } else if (value == options[_optionLogOutIndex]) {
      doLogout(context);
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void doLogout(BuildContext context) async {
    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogLoading);

    await progressDialog.show();

    await _sessionProvider.logOut();
    await Navigator.pushNamedAndRemoveUntil(context, 'login', (r) => false);

    await progressDialog.hide();
  }
}
