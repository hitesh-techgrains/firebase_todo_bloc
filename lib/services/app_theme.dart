import 'package:flutter/material.dart';

/// Enum to represent the available app themes.
enum AppTheme { darkTheme, lightTheme }

class AppThemes {
  static final appThemeData = {
    AppTheme.darkTheme: ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      //backgroundColor: const Color(0xFF212121),
      dividerColor: Colors.black54,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.white),
      textButtonTheme: TextButtonThemeData(style: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.white))),
      textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.white)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.grey, unselectedItemColor: Colors.white),
    ),

    //
    //
    AppTheme.lightTheme: ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.white,
      brightness: Brightness.light,

      //backgroundColor: const Color(0xFFE5E5E5),
      dividerColor: const Color(0xff757575),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.black, foregroundColor: Colors.white),
      textButtonTheme: TextButtonThemeData(style: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.black))),
      textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.black)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
      ),
    ),
  };
}
