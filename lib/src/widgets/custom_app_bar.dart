import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/repositories/session_repository.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:psp_admin/src/utils/utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SearchDelegate searchDelegate;
  final String title;
  final PreferredSizeWidget bottom;

  CustomAppBar({this.searchDelegate, @required this.title, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: appBarActions(context),
      bottom: bottom,
    );
  }

  List<Widget> appBarActions(BuildContext context) {
    return [
      (searchDelegate != null)
          ? IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: searchDelegate);
              })
          : Container(),
      CustomPopupMenu()
    ];
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));
}

class CustomPopupMenu extends StatelessWidget {
  final _sessionProvider = SessionRepository();

  final _optionSettingsIndex = 1;
  final _optionChangeTheme = 2;
  final _optionLogOutIndex = 3;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        onSelected: (value) {
          onItemMenuSelected(value, context);
        },
        itemBuilder: (context) => getPopUpMenuOptions(context)
            .map((option) => (option.isNotEmpty)
                ? PopupMenuItem<String>(value: option, child: Text(option))
                : null)
            .toList());
  }

  List<String> getPopUpMenuOptions(BuildContext context) => [
        '',
        S.of(context).optionSettings,
        (Preferences().theme == 1)
            ? S.of(context).darkMode
            : S.of(context).lightMode,
        S.of(context).optionLogOut,
      ];

  void onItemMenuSelected(String value, BuildContext context) {
    final options = getPopUpMenuOptions(context);

    if (value == options[_optionSettingsIndex]) {
    } else if (value == options[_optionChangeTheme]) {
      final appTheme = Provider.of<ThemeChanger>(context, listen: false);
      appTheme.isDarkTheme = !appTheme.isDarkTheme;
    } else if (value == options[_optionLogOutIndex]) {
      doLogout(context);
    }
  }

  void doLogout(BuildContext context) async {
    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogLoading);

    await progressDialog.show();

    await Navigator.pushNamedAndRemoveUntil(context, 'login', (r) => false);
    await _sessionProvider.logOut();

    await Preferences().clearPreferences();

    await progressDialog.hide();
  }
}
