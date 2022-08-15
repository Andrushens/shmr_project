import 'package:path/path.dart';
import 'package:shmr/model/task/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static late final Database database;

  static Future<void> init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'done_app_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks( '
          'id TEXT NOT NULL PRIMARY KEY, '
          'text TEXT NOT NULL, '
          'importance TEXT NOT NULL, '
          'deadline INTEGER, '
          'done INTEGER NOT NULL, '
          'color TEXT, '
          'created_at INTEGER NOT NULL, '
          'changed_at INTEGER NOT NULL, '
          'last_updated_by TEXT NOT NULL '
          '); ',
        );
      },
      version: 1,
    );
  }

  static Future<List<Task>> fetchTasks() async {
    final List<Map<String, dynamic>> maps = await database.query(
      'tasks',
      orderBy: 'created_at',
    );
    return List.generate(
      maps.length,
      (i) {
        final map = Map<String, Object?>.from(maps[i]);
        if (map['done'] == 1) {
          map['done'] = true;
        } else {
          map['done'] = false;
        }
        return Task.fromJson(map);
      },
    );
  }

  static Future<void> addTask(Task task) async {
    final json = task.toJson();
    json['done'] = task.done ? 1 : 0;
    await database.insert(
      'tasks',
      json,
    );
  }

  static Future<void> updateTask(Task task) async {
    final json = task.toJson();
    json['done'] = task.done ? 1 : 0;
    await database.update(
      'tasks',
      json,
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<void> deleteTask(String id) async {
    await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> addTasksList(List<Task> tasks) async {
    final batch = database.batch();
    for (final task in tasks) {
      final json = task.toJson();
      json['done'] = task.done ? 1 : 0;
      batch.insert(
        'tasks',
        json,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }
}
