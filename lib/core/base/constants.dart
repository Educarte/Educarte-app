import 'package:flutter/material.dart';

ThemeData themeData (BuildContext context) => Theme.of(context);

double screenWidth (BuildContext context) => MediaQuery.of(context).size.width;

double screenHeight (BuildContext context) => MediaQuery.of(context).size.height;

ColorScheme colorScheme (BuildContext context) => themeData(context).colorScheme;

TextTheme textTheme (BuildContext context) => themeData(context).textTheme;