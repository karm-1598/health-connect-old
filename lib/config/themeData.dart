import 'package:flutter/material.dart';
import 'package:health_connect2/config/colors.dart';

var lightTheme = ThemeData(
  useMaterial3: true,
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: lightBgColor,
    filled: true,
    prefixIconColor: lightLabelColor,
    labelStyle: TextStyle(fontFamily: 'Questrial', fontWeight: FontWeight.w500,color: Colors.black),
    hintStyle: TextStyle(fontFamily: 'Questrial', fontWeight: FontWeight.w500,color: Colors.black),
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
    surfaceContainer: lightDivColor,
    outline: Color.fromARGB(171, 15, 25, 77)
  ),
  textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontFamily: "Questrial",
          fontSize: 24,
          color: lightFontColor,
          fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(
          fontFamily: "Questrial",
          fontSize: 20,
          color:lightFontColor ,
          fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(
          fontFamily: "Questrial",
          fontSize: 15,
          color: lightFontColor,
          fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(
          fontFamily: "Questrial",
          fontSize: 16,
          color: lightFontColor,
          fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(
          fontFamily: "Questrial",
          fontSize: 15,
          color: lightFontColor,
          fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          fontFamily: "Questrial",
          fontSize: 13,
          color: lightFontColor,
          fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          fontFamily: "Questrial",
          fontSize: 13,
          color: lightFontColor,
          fontWeight: FontWeight.w300)),
);

// dark theme
var darkTheme = ThemeData(
  scaffoldBackgroundColor: darkBgColor,
  useMaterial3: true,
  
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: darkBgColor,
    filled: true,
    prefixIconColor: darkLabelColor,
    labelStyle: TextStyle(fontFamily: 'Questrial', fontWeight: FontWeight.w500,color: darkLabelColor),
    hintStyle: TextStyle(fontFamily: 'Questrial', fontWeight: FontWeight.w500,color: darkLabelColor),
  ),
  appBarTheme: const AppBarTheme(
    titleSpacing: 1,
    backgroundColor: darkAppbarColor,
    foregroundColor: darkLabelColor,
    centerTitle: true,
    toolbarHeight: 100,

  ),
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    surface: darkBgColor,
    onSurface: darkFontColor,
    primaryContainer: darkPrimaryColor,
    primary: darkPrimaryColor,
    surfaceContainer: darkDivColor,
    secondaryContainer: darkSecDivColor,
    outline: Color.fromARGB(156, 36, 63, 243)
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
