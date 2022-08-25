import 'package:clone_flutter_app/component/dory_colors.dart';
import 'package:flutter/material.dart';

class DoryThemes {
  static ThemeData lightTheme() => ThemeData(
        primarySwatch: DoryColors.primaryMaterialColor,
        fontFamily: 'GmarketSansTTF',
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.white,
        brightness: Brightness.light,
        textTheme: _textTheme,
      );

  static ThemeData darkTheme() => ThemeData(
        primarySwatch: DoryColors.primaryMaterialColor,
        fontFamily: 'GmarketSansTTF',
        splashColor: Colors.white,
        brightness: Brightness.dark,
        textTheme: _textTheme,
      );

  static const TextTheme _textTheme = TextTheme(
    headline4: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    button: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),
  );
}