import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/src/blocs/provider.dart';
import 'package:psp_admin/src/models/fab_model.dart';
import 'package:psp_admin/src/routes/routes.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding();
  final prefs = Preferences();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var preferences = Preferences();

    return MultiProvider(
      providers: [
        Provider<BlocProvider>(
          create: (_) => BlocProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FabModel(),
        )
      ],
      child: MaterialApp(
          title: 'PSP - ADMIN',
          debugShowCheckedModeBanner: false,
          initialRoute: (preferences.token != '') ? 'projects' : 'login',
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
          supportedLocales: S.delegate.supportedLocales),
    );
  }
}
