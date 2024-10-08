import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData get theme => ThemeData(
  useMaterial3: true,
  primaryColor: _colorScheme.primary,
  colorScheme: _colorScheme,
  iconTheme: IconThemeData(color: _colorScheme.outline),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: _colorScheme.onInverseSurface
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: _colorScheme.onSurfaceVariant
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16
    )
  )
);

ColorScheme get _colorScheme => const ColorScheme(
  brightness: Brightness.light,
  primary:  Color(0xff547B9A),
  onPrimary: Colors.white,
  secondary: Color(0xffEFC34C),
  onSecondary: Color(0xffC86189),
  error:  Color.fromRGBO(162, 24, 14, 1),
  onError: Colors.white,
  onInverseSurface: Color(0xFF474C51),
  onSurfaceVariant: Color(0xffF5F5F5),
  surface:  Color(0xffF0F0F3),
  onSurface:  Color(0xFF74787D),
  outline:  Color(0xffA0A4A8)
);
