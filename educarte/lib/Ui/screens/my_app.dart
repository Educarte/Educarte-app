import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../routes.dart';
import '../styles/theme/theme.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('pt', 'BR')
      ],  
      title: 'Educarte',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: Routes.router,
    );
  }
}
