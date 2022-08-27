import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ConstStyles {
  static const importanceColorFBField = 'importance_color';

  static const kRed = Color(0xFFFF3B30);
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
    // 'X-Generate-Fails': 33,
  };

  static const baseUrl = 'https://beta.mrdekk.ru/todobackend/';

  static const fetchTasksPath = 'list';
  static const patchTasksPath = 'list';
  static const addTaskPath = 'list';
  static String deleteTaskPath(String taskId) => 'list/$taskId';
  static String updateTaskPath(String taskId) => 'list/$taskId';

  static const revisionField = 'revision';
  static const elementField = 'element';
  static const statusField = 'status';
  static const listField = 'list';

  static const methodPatch = 'PATCH';
  static const methodGet = 'GET';
}

class ConstPreferences {
  static const darkModeKey = 'dark_mode_key';
  static const androidSdkVersionKey = 'android_sdk_version_key';
  static const revisionLocalKey = 'revision_local_key';
  static const revisionRemoteKey = 'revision_remote_key';
}
