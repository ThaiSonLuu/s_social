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
  onPrimaryContainer: Color(0xFFCDCDCD),
  onPrimaryFixed: Color(0xFF000000),
  onSecondaryFixed: Color(0xFF5A5A5A),
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
  onPrimaryContainer: Color(0xFF444444),
  onPrimaryFixed: Color(0xFFFFFFFF),
  onSecondaryFixed: Color(0xFFE0E0E0),
);
