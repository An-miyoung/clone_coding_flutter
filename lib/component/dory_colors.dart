import 'package:flutter/material.dart';

class DoryColors {
  static const int _primaryValue = 0xFF151515;
  static const primaryColor = Color(_primaryValue);

  static const MaterialColor primaryMaterialColor = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(_primaryValue),
      100: Color(_primaryValue),
      200: Color(_primaryValue),
      300: Color(_primaryValue),
      400: Color(_primaryValue),
      500: Color(_primaryValue),
      600: Color(_primaryValue),
      700: Color(_primaryValue),
      800: Color(_primaryValue),
      900: Color(_primaryValue),
    },
  );
}
