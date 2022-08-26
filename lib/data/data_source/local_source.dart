import 'package:shmr/model/task/task.dart';
import 'package:shmr/service/database_service.dart';

abstract class LocalSource {
  Future<List<Task>> fetchTasks();
  Future<void> addTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> updateTask(Task task);
  Future<void> addTasksList(List<Task> tasks);
}

class LocalSourceImpl implements LocalSource {
  @override
  Future<List<Task>> fetchTasks() async {
    try {
      final tasks = await DatabaseService.fetchTasks();
      return tasks;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      await DatabaseService.addTask(task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await DatabaseService.deleteTask(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      await DatabaseService.updateTask(task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addTasksList(List<Task> tasks) async {
    try {
      await DatabaseService.addTasksList(tasks);
    } catch (e) {
      rethrow;
    }
  }
}
