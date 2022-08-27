import 'package:shmr/utils/const.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalSource {
  Future<List<Map<String, dynamic>>> fetchTasks();
  Future<void> addTask(Map<String, dynamic> taskMap);
  Future<void> deleteTask(String id);
  Future<void> updateTask(String id, Map<String, dynamic> taskMap);
  Future<void> addTasksList(List<Map<String, dynamic>> tasks);
}

class LocalSourceImpl implements LocalSource {
  LocalSourceImpl(this.database);

  final Database database;

  @override
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final List<Map<String, dynamic>> maps = await database.query(
      ConstLocal.tasksTableName,
      orderBy: ConstLocal.createdAtField,
    );
    final result = maps.map((e) {
      final resMap = Map<String, dynamic>.from(e);
      resMap[ConstLocal.doneField] = e[ConstLocal.doneField] == 1;
      return resMap;
    }).toList();
    return result;
  }

  @override
  Future<void> addTask(Map<String, dynamic> taskMap) async {
    final resMap = Map<String, dynamic>.from(taskMap);
    resMap[ConstLocal.doneField] =
        taskMap[ConstLocal.doneField] == true ? 1 : 0;
    await database.insert(
      ConstLocal.tasksTableName,
      resMap,
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
  Future<void> updateTask(String id, Map<String, dynamic> taskMap) async {
    final resMap = Map<String, dynamic>.from(taskMap);
    resMap[ConstLocal.doneField] =
        taskMap[ConstLocal.doneField] == true ? 1 : 0;
    await database.update(
      ConstLocal.tasksTableName,
      resMap,
      where: '${ConstLocal.idField} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> addTasksList(List<Map<String, dynamic>> tasksMaps) async {
    final batch = database.batch();
    for (final taskMap in tasksMaps) {
      final resMap = Map<String, dynamic>.from(taskMap);
      resMap[ConstLocal.doneField] =
          taskMap[ConstLocal.doneField] == true ? 1 : 0;
      batch.insert(
        ConstLocal.tasksTableName,
        resMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }
}
