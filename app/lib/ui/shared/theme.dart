import 'package:flutter/material.dart';

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.grey,
    brightness: Brightness.dark,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 40,
    ),
    titleLarge: TextStyle(
      fontSize: 24,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
    ),
  ),
  useMaterial3: true,
);
