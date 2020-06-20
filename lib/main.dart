import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/providers/models/fab_model.dart';
import 'package:psp_admin/src/routes/routes.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding();
  final prefs = Preferences();
  await prefs.initPrefs();

  runApp(MultiProvider(providers: [
    Provider<BlocProvider>(
      create: (_) => BlocProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => FabModel(),
    ),
    ChangeNotifierProvider(create: (_) => ThemeChanger(prefs.theme))
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    return MaterialApp(
        title: 'PSP - ADMIN',
        debugShowCheckedModeBanner: false,
        initialRoute: (preferences.token != '') ? 'projects' : 'login',
        routes: getApplicationRoutes(),
        // home: ProgramItemsPage(),
        theme: Provider.of<ThemeChanger>(context).currentTheme,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate
        ],
        supportedLocales: S.delegate.supportedLocales);
  }
}
