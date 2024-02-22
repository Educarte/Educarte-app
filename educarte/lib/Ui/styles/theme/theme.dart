import 'package:flutter/material.dart';

ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    iconTheme: IconThemeData(color: _colorScheme.outline),
    textTheme: TextTheme(
        titleLarge: TextStyle(
            color: _colorScheme.onBackground
        )
    )
);

ColorScheme get _colorScheme => ColorScheme(
  brightness: Brightness.light,
  primary: const Color(0xff547B9A),
  onPrimary: Colors.white,
  secondary: Colors.amber[700]!,
  onSecondary: Colors.white,
  error: const Color.fromRGBO(162, 24, 14, 1),
  onError: Colors.white,
  background: const Color(0xffF0F0F3),
  onBackground: const Color(0xffF5F5F5),
  surface: const Color(0xFF74787D),
  onSurface: const Color(0xFFFFFFFF),
  outline: const Color(0xffA0A4A8)
);
