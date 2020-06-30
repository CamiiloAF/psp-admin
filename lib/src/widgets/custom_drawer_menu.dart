import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
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
            SafeArea(
              child: Container(
                width: double.infinity,
                height: 200,
                child: CircleAvatar(
                  child: Text(
                    'FH',
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              ),
            ),
            CustomListTile(title: s.appBarTitleProjects, onTap: () => _goToNewPage(context, 'projects')),
            CustomListTile(title: s.appBarTitleLanguages, onTap: () => _goToNewPage(context, 'languages')),
            CustomListTile(title: 'Usuarios libres', onTap: () {}),
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

  void _goToNewPage(BuildContext context,String routeName) => Navigator.pushNamed(context, routeName);
}
