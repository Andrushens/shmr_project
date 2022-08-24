import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shmr/view/theme/theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit({required this.importanceColor})
      : super(
          getDarkTheme(importanceColor: importanceColor),
        );

  final Color importanceColor;

  late final lightTheme = getLightTheme(importanceColor: importanceColor);
  late final darkTheme = getDarkTheme(importanceColor: importanceColor);

  bool get isDarkMode => state.brightness == Brightness.dark;

  void changeTheme() {
    emit(isDarkMode ? lightTheme : darkTheme);
  }
}
