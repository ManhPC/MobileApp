import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  dividerColor: Colors.transparent,

  primaryColor: const Color(0xff2c2f32), //text
  textTheme: const TextTheme(
    titleSmall: TextStyle(
      color: Color(0xff595e72),
    ),
  ),

  secondaryHeaderColor: Colors.orange.shade700, // header choice
  hintColor: const Color(0xffcacccd), // hinttext
  buttonTheme: ButtonThemeData(
    //button
    colorScheme: ColorScheme.light(
      background: Colors.orange.shade700,
      onBackground: Colors.grey.shade200,
      primary: Colors.white,
    ),
  ),
  cardColor: Colors.orange.shade700, //border
  appBarTheme: const AppBarTheme(
    //appbar
    backgroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    //background
    background: Colors.white,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade300,
    tertiary: Colors.grey[150],
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //bottom bar
    backgroundColor: Colors.orange.shade700,
    selectedItemColor: const Color(0xff1d2029),
    unselectedItemColor: const Color(0xff595e72),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
    modalBackgroundColor: Colors.orange.shade700,
    modalBarrierColor: const Color.fromARGB(150, 245, 123, 0),
  ),
);
