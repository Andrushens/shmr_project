import 'package:flutter/material.dart';

ThemeData getLightTheme({Color importanceColor = const Color(0xFFFF3B30)}) {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      color: Color(0xFFF7F6F2),
    ),
    hintColor: Colors.black.withOpacity(0.3),
    dividerColor: Colors.black.withOpacity(0.2),
    primaryColor: const Color(0xFFF7F6F2),
    scaffoldBackgroundColor: const Color(0xFFF7F6F2),
    selectedRowColor: const Color(0xFF34C759),
    unselectedWidgetColor: const Color(0xFF8E8E93),
    shadowColor: Colors.black.withOpacity(0.1),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFF007AFF),
      onPrimary: Colors.white,
      secondary: const Color(0xFF007AFF),
      onSecondary: Colors.black,
      error: const Color(0xFFFF3B30),
      onError: Colors.black,
      background: const Color(0xFFF7F6F2),
      onBackground: Colors.black,
      surface: const Color(0xFFFFFFFF),
      onSurface: Colors.black,
      outline: const Color(0xFF8E8E93),
      surfaceVariant: importanceColor,
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
      subtitle2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
      ),
      button: TextStyle(
        fontSize: 14,
      ),
    ),
  );
}

ThemeData getDarkTheme({Color importanceColor = const Color(0xFFFF3B30)}) {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      color: Color(0xFF252528),
    ),
    hintColor: Colors.white.withOpacity(0.4),
    dividerColor: Colors.white.withOpacity(0.2),
    primaryColor: const Color(0xFF161618),
    scaffoldBackgroundColor: const Color(0xFF161618),
    dialogBackgroundColor: const Color(0xFF3C3C3F),
    unselectedWidgetColor: Colors.black.withOpacity(0.2),
    selectedRowColor: const Color(0xFF32D74B),
    shadowColor: Colors.transparent,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF0A84FF),
      onPrimary: const Color(0xFFFFFFFF),
      secondary: const Color(0xFF0A84FF),
      onSecondary: Colors.white,
      error: const Color(0xFFFF453A),
      onError: Colors.black,
      background: const Color(0xFF252528),
      onBackground: Colors.white,
      surface: const Color(0xFF252528),
      onSurface: Colors.white,
      outline: const Color(0xFF8E8E93),
      surfaceVariant: importanceColor,
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
      subtitle2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
      ),
      button: TextStyle(
        fontSize: 14,
      ),
    ),
  );
}
