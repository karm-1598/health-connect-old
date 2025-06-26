import 'package:flutter/material.dart';
import 'package:health_connect2/config/colors.dart';

var lightTheme = ThemeData(
  useMaterial3: true,
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: lightBgColor,
    filled: true,
    prefixIconColor: lightLabelColor,
    labelStyle: TextStyle(fontFamily: 'Questrial', fontWeight: FontWeight.w500),
    hintStyle: TextStyle(fontFamily: 'Questrial', fontWeight: FontWeight.w500),
  ),
  appBarTheme: const AppBarTheme(
    titleSpacing: 1,
    backgroundColor: lightAppbarColor,
    foregroundColor: lightLabelColor,
    centerTitle: true,
    toolbarHeight: 100,
  ),
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    surface: lightBgColor,
    onSurface: lightFontColor,
    primaryContainer: lightPrimaryColor,
    primary: lightPrimaryColor,
  ),
  textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontFamily: "Questrial",
          fontSize: 24,
          color: lightLabelColor,
          fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(
          fontFamily: "Questrial",
          fontSize: 20,
          color:lightLabelColor ,
          fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(
          fontFamily: "Questrial",
          fontSize: 15,
          color: lightLabelColor,
          fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(
          fontFamily: "Questrial",
          fontSize: 16,
          color: lightLabelColor,
          fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(
          fontFamily: "Questrial",
          fontSize: 15,
          color: lightFontColor,
          fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          fontFamily: "Questrial",
          fontSize: 13,
          color: lightLabelColor,
          fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          fontFamily: "Questrial",
          fontSize: 13,
          color: lightLabelColor,
          fontWeight: FontWeight.w300)),
);

// dark theme
var darkTheme = ThemeData(
  useMaterial3: true,
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: darkBgColor,
    filled: true,
    prefixIconColor: darkLabelColor,
    labelStyle: TextStyle(fontFamily: 'Questrial', fontWeight: FontWeight.w500),
    hintStyle: TextStyle(fontFamily: 'Questrial', fontWeight: FontWeight.w500),
  ),
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    surface: darkBgColor,
    onSurface: darkFontColor,
    primaryContainer: darkPrimaryColor,
    primary: darkPrimaryColor,
  ),
  textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontFamily: "Questrial",
          fontSize: 24,
          color: darkFontColor,
          fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(
          fontFamily: "Questrial",
          fontSize: 20,
          color: darkFontColor,
          fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(
          fontFamily: "Questrial",
          fontSize: 15,
          color: darkFontColor,
          fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(
          fontFamily: "Questrial",
          fontSize: 16,
          color: darkFontColor,
          fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(
          fontFamily: "Questrial",
          fontSize: 15,
          color: darkFontColor,
          fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          fontFamily: "Questrial",
          fontSize: 13,
          color: darkFontColor,
          fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          fontFamily: "Questrial",
          fontSize: 13,
          color: darkFontColor,
          fontWeight: FontWeight.w300)),
);
