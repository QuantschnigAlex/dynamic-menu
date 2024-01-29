import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.green,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.green,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.green,
    ),
  ),
);
