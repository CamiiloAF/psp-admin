import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/pages/languages/languages_page.dart';
import 'package:psp_admin/src/pages/profile/profile_page.dart';
import 'package:psp_admin/src/pages/projects/projects_page.dart';
import 'package:psp_admin/src/pages/settings/settings_page.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';

import 'custom_list_tile.dart';

class CustomDrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final s = S.of(context);
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            _buildCircleAvatar(context),
            CustomListTile(
                title: s.appBarTitleProjects,
                onTap: () => _goToNewPage(context, ProjectsPage.ROUTE_NAME)),
            CustomListTile(
                title: s.appBarTitleLanguages,
                onTap: () => _goToNewPage(context, LanguagesPage.ROUTE_NAME)),
            CustomListTile(
                title: S.of(context).optionSettings,
                onTap: () => _goToNewPage(context, SettingsPage.ROUTE_NAME)),
            Divider(),
            ListTile(
              leading: Icon(Icons.brightness_4),
              title: Text(s.darkMode),
              trailing: Switch.adaptive(
                  value: appTheme.isDarkTheme,
                  activeColor: appTheme.currentTheme.accentColor,
                  onChanged: (value) => appTheme.isDarkTheme = value),
            ),
          ],
        ),
      ),
    );
  }

  SafeArea _buildCircleAvatar(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        height: 200,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, ProfilePage.ROUTE_NAME),
            child: Text(
              _getCurrentUserNameInitials(),
              style: TextStyle(fontSize: 50),
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrentUserNameInitials() {
    final currentUser = json.decode(Preferences().curentUser);

    final firstName = currentUser['first_name'].toString().trimLeft();
    final lastName = currentUser['last_name'].toString().trimLeft();

    return '${firstName[0]}${lastName[0]}';
  }

  void _goToNewPage(BuildContext context, String routeName) =>
      Navigator.pushNamed(context, routeName);
}
