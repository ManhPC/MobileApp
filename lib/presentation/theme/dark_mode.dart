import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  dividerColor: Colors.transparent,
  //color text normal
  primaryColor: const Color(0xffffffff),
  //color text title small
  textTheme: const TextTheme(
    titleSmall: TextStyle(
      color: Color(0xffa0a3af),
    ),
  ),
  //color text header and text button
  secondaryHeaderColor: const Color(0xffe7ab21),
  // color hint text
  hintColor: const Color(0xff595E72),
  //color elevated button
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.dark(
      background: Color(0xffe7ab21),
      onBackground: Color(0xFF292D38),
      primary: Colors.black,
    ),
  ),
  //color border card
  cardColor: const Color(0xffe7ab21),

  // appbar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff131721),
  ),

  //body background
  colorScheme: const ColorScheme.dark(
    background: Color(0xff131721),
    primary: Color(0xff1d2029),
    secondary: Color(0xff313645),
    // secondary: Colors.grey.shade100,
    tertiary: Color(0xFF292D38),
  ),
  // bottombar background
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xff313645),
    selectedItemColor: Color(0xffe7ab21),
    unselectedItemColor: Color(0xffa3a0af),
  ),

  //bottom sheet theme
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xff1d2029),
    modalBackgroundColor: Color(0xffe7ab21),
    modalBarrierColor: Color.fromARGB(160, 231, 171, 33),
  ),
);
