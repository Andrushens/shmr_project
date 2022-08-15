import 'package:path/path.dart';
import 'package:shmr/model/task/task.dart';
import 'package:shmr/utils/const.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static late final Database database;

  static Future<void> init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), ConstLocal.databaseName),
      onCreate: (db, version) {
        return db.execute(ConstLocal.createTasksTable);
      },
      version: 1,
    );
  }

  static Future<List<Task>> fetchTasks() async {
    final List<Map<String, dynamic>> maps = await database.query(
      ConstLocal.tasksTableName,
      orderBy: ConstLocal.createdAtField,
    );
    return List.generate(
      maps.length,
      (i) {
        final map = Map<String, Object?>.from(maps[i]);
        map[ConstLocal.doneField] = map[ConstLocal.doneField] == 1;
        return Task.fromJson(map);
      },
    );
  }

  static Future<void> addTask(Task task) async {
    final map = task.toJson();
    map[ConstLocal.doneField] = task.done ? 1 : 0;
    await database.insert(
      ConstLocal.tasksTableName,
      map,
    );
  }

  static Future<void> updateTask(Task task) async {
    final map = task.toJson();
    map[ConstLocal.doneField] = task.done ? 1 : 0;
    await database.update(
      ConstLocal.tasksTableName,
      map,
      where: '${ConstLocal.idField} = ?',
      whereArgs: [task.id],
    );
  }

  static Future<void> deleteTask(String id) async {
    await database.delete(
      ConstLocal.tasksTableName,
      where: '${ConstLocal.idField} = ?',
      whereArgs: [id],
    );
  }

  static Future<void> addTasksList(List<Task> tasks) async {
    final batch = database.batch();
    for (final task in tasks) {
      final map = task.toJson();
      map[ConstLocal.doneField] = task.done ? 1 : 0;
      batch.insert(
        ConstLocal.tasksTableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }
}
