import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.lightBlue,
  onPrimary: Colors.white,
  secondary: Colors.blueAccent,
  onSecondary: Colors.white,
  error: Colors.redAccent,
  onError: Colors.white,
  surface: Colors.white,
  onSurface: Colors.black,
  surfaceContainer: const Color(0xFFE7E7E7),
  surfaceContainerLowest: Colors.lightBlue.shade50,
);

final darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.lightBlue,
  onPrimary: Colors.black,
  secondary: Colors.blueAccent,
  onSecondary: Colors.black,
  error: Colors.redAccent,
  onError: Colors.white,
  surface: Colors.black,
  onSurface: Colors.white,
  surfaceContainer: const Color(0xFF363636),
  surfaceContainerLowest: Colors.blue.shade900,
);
