import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class Const {
  static const kBackPrimary = Color(0xFFF7F6F2);
  static const kBackSecondary = Color(0xFFFFFFFF);
  static const kBackElevated = Color(0xFFFFFFFF);
  static const kRed = Color(0xFFFF3B30);
  static const kGreen = Color(0xFF34C759);
  static const kBlue = Color(0xFF007AFF);
  static const kGray = Color(0xFF8E8E93);
  static const kLightGray = Color(0xFFD1D1D6);

  static final themeData = ThemeData(
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
