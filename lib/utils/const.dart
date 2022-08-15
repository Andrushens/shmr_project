import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ConstStyles {
  static const importanceColorFBField = 'importance_color';

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

class ConstLocal {
  static const databaseName = 'done_app_database.db';
  static const tasksTableName = 'tasks';

  static const idField = 'id';
  static const textField = 'text';
  static const importanceField = 'importance';
  static const deadlineField = 'deadline';
  static const doneField = 'done';
  static const colorField = 'color';
  static const createdAtField = 'created_at';
  static const changedAtField = 'changed_at';
  static const lastUpdatedByField = 'last_updated_by';

  static const String createTasksTable = 'CREATE TABLE $tasksTableName( '
      '$idField TEXT NOT NULL PRIMARY KEY, '
      '$textField TEXT NOT NULL, '
      '$importanceField TEXT NOT NULL, '
      '$deadlineField INTEGER, '
      '$doneField INTEGER NOT NULL, '
      '$colorField TEXT, '
      '$createdAtField INTEGER NOT NULL, '
      '$changedAtField INTEGER NOT NULL, '
      '$lastUpdatedByField TEXT NOT NULL '
      '); ';
}

class ConstRemote {
  static const receiveTimeout = 16000;
  static const sendTimeout = 16000;

  static const revisionHeader = 'X-Last-Known-Revision';
  static const baseHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer Taixpool',
  };

  static const baseUrl = 'https://beta.mrdekk.ru/todobackend/';

  static const fetchTasksPath = 'list';
  static const addTaskPath = 'list';
  static String deleteTaskPath(String taskId) => 'list/$taskId';
  static String updateTaskPath(String taskId) => 'list/$taskId';

  static const revisionField = 'revision';
  static const elementField = 'element';
  static const statusField = 'status';
  static const listField = 'list';
}
