import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:psp_admin/src/blocs/provider.dart';
import 'package:psp_admin/src/routes/routes.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding();
  final prefs = new Preferences();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Preferences preferences = new Preferences();
    print(preferences.token);
    return Provider(
      child: MaterialApp(
        title: 'PSP - ADMIN',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: getApplicationRoutes(),
        theme: ThemeData(
          primaryColor: Color(0xFF607d8b),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate
        ],
        supportedLocales: S.delegate.supportedLocales        
      ),
    );
  }
}
