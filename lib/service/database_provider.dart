import 'package:path/path.dart';
import 'package:shmr/model/task/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static late final Database database;

  DatabaseProvider._();

  static Future<void> init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'done_app_database.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE tasks('
            'id TEXT NOT NULL PRIMARY KEY,'
            'text TEXT NOT NULL,'
            'importance TEXT NOT NULL,'
            'deadline INTEGER,'
            'done INTEGER NOT NULL,'
            'color TEXT,'
            'created_at INTEGER NOT NULL,'
            'changed_at INTEGER NOT NULL,'
            'last_updated_by TEXT NOT NULL'
            ');');
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
        var map = Map<String, Object?>.from(maps[i]);
        map['done'] = map['done'] == 1 ? true : false;
        return Task.fromJson(map);
      },
    );
  }

  static Future<void> addTask(Task task) async {
    var json = task.toJson();
    json['done'] = task.done ? 1 : 0;
    await database.insert(
      'tasks',
      json,
    );
  }

  static Future<void> updateTask(Task task) async {
    var json = task.toJson();
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
    var batch = database.batch();
    for (var task in tasks) {
      var json = task.toJson();
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
