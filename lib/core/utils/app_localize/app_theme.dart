import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.lightBlue,
  onPrimary: Colors.white,
  secondary: Colors.blueAccent,
  onSecondary: Colors.white,
  error: Colors.redAccent,
  onError: Colors.white,
  surface: Colors.white,
  onSurface: Colors.black,
  surfaceContainer: Color(0xFFE7E7E7),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.lightBlue,
  onPrimary: Colors.black,
  secondary: Colors.blueAccent,
  onSecondary: Colors.black,
  error: Colors.redAccent,
  onError: Colors.white,
  surface: Colors.black,
  onSurface: Colors.white,
  surfaceContainer: Color(0xFF363636),
);
