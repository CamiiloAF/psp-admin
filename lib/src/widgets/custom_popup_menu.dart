import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/pages/experiences/experiences_page.dart';
import 'package:psp_admin/src/pages/profile/profile_page.dart';
import 'package:psp_admin/src/pages/settings/settings_page.dart';
import 'package:psp_admin/src/repositories/session_repository.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:psp_admin/src/utils/utils.dart';

class CustomPopupMenu extends StatelessWidget {
  final _optionSettingsIndex = 1;
  final _optionChangeTheme = 2;
  final _optionProfile = 3;
  final _optionLogOutIndex = 4;

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

  List<String> getPopUpMenuOptions(BuildContext context) {
    final s = S.of(context);
    return [
      '',
      s.optionSettings,
      (Preferences().theme == 1) ? s.darkMode : s.lightMode,
      s.appBarTitleProfile,
      s.optionLogOut,
    ];
  }

  void onItemMenuSelected(String value, BuildContext context) {
    final options = getPopUpMenuOptions(context);

    if (value == options[_optionSettingsIndex]) {
      _onSelectedOptionSettings(context);
    } else if (value == options[_optionChangeTheme]) {
      _onSelectedOptionChangeTheme(context);
    } else if (value == options[_optionProfile]) {
      _onSelectedOptionProfile(context);
    } else if (value == options[_optionLogOutIndex]) {
      doLogout(context);
    }
  }

  void _onSelectedOptionSettings(BuildContext context) {
    final currentRouteName = ModalRoute.of(context).settings.name;
    if (currentRouteName != SettingsPage.ROUTE_NAME) {
      Navigator.pushNamed(context, SettingsPage.ROUTE_NAME);
    }
  }

  void _onSelectedOptionChangeTheme(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context, listen: false);
    appTheme.isDarkTheme = !appTheme.isDarkTheme;
  }

  void _onSelectedOptionProfile(BuildContext context) {
    final currentRouteName = ModalRoute.of(context).settings.name;
    if (currentRouteName != ProfilePage.ROUTE_NAME &&
        currentRouteName != ExperiencesPage.ROUTE_NAME) {
      Navigator.pushNamed(context, ProfilePage.ROUTE_NAME);
    }
  }

  static void doLogout(BuildContext context) async {
    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogLoading);

    await progressDialog.show();

    await SessionRepository().logOut();

    await Navigator.pushNamedAndRemoveUntil(context, 'login', (r) => false);
    await progressDialog.hide();
  }
}
