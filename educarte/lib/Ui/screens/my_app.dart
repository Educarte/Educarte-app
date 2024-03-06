import 'package:flutter/material.dart';

import '../routes.dart';
import '../styles/theme/theme.dart';
import 'login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Educarte',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: Routes.router,
    );
  }
}
