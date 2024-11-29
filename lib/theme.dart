import 'package:flutter/material.dart';

class GlobalThemeData {
  // Define a light theme
  static final lightThemeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: const ColorScheme.light(
      secondary: Colors.blueAccent,  // Use secondary instead of accentColor
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),  // bodyLarge instead of bodyText1
      bodyMedium: TextStyle(color: Colors.black54),  // bodyMedium instead of bodyText2
    ),
  );

  // Define a dark theme
  static final darkThemeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    colorScheme: const ColorScheme.dark(
      secondary: Colors.cyanAccent,  // Use secondary instead of accentColor
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.blueGrey,
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.cyanAccent,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),  // bodyLarge instead of bodyText1
      bodyMedium: TextStyle(color: Colors.white70),  // bodyMedium instead of bodyText2
    ),
  );
}
