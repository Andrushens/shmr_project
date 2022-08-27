import 'package:shmr/domain/model/task/task.dart';
import 'package:shmr/utils/const.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalSource {
  Future<List<Task>> fetchTasks();
  Future<void> addTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> updateTask(Task task);
  Future<void> saveTasks(List<Task> tasks);
}

class LocalSourceImpl implements LocalSource {
  LocalSourceImpl(this.database);

  final Database database;

  @override
  Future<List<Task>> fetchTasks() async {
    final List<Map<String, dynamic>> maps = await database.query(
      ConstLocal.tasksTableName,
      orderBy: ConstLocal.createdAtField,
    );
    final result = maps.map((e) {
      final resMap = Map<String, dynamic>.from(e);
      resMap[ConstLocal.doneField] = e[ConstLocal.doneField] == 1;
      return Task.fromJson(resMap);
    }).toList();
    return result;
  }

  @override
  Future<void> addTask(Task task) async {
    final taskMap = task.toJson();
    taskMap[ConstLocal.doneField] =
        taskMap[ConstLocal.doneField] == true ? 1 : 0;
    await database.insert(
      ConstLocal.tasksTableName,
      taskMap,
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await database.delete(
      ConstLocal.tasksTableName,
      where: '${ConstLocal.idField} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskMap = task.toJson();
    taskMap[ConstLocal.doneField] =
        taskMap[ConstLocal.doneField] == true ? 1 : 0;
    await database.update(
      ConstLocal.tasksTableName,
      taskMap,
      where: '${ConstLocal.idField} = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    await database.delete(ConstLocal.tasksTableName);
    final batch = database.batch();
    for (final task in tasks) {
      final taskMap = task.toJson();
      taskMap[ConstLocal.doneField] = task.done ? 1 : 0;
      batch.insert(
        ConstLocal.tasksTableName,
        taskMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }
}
