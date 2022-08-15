import 'package:shmr/model/task/task.dart';
import 'package:shmr/service/database_provider.dart';

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
      var tasks = await DatabaseProvider.fetchTasks();
      return tasks;
    } catch (e) {
      //TODO handle exception
      rethrow;
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      await DatabaseProvider.addTask(task);
    } catch (e) {
      //TODO handle exception
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await DatabaseProvider.deleteTask(id);
    } catch (e) {
      //TODO handle exception
      rethrow;
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      await DatabaseProvider.updateTask(task);
    } catch (e) {
      //TODO handle exception
      rethrow;
    }
  }

  Future<void> addTasksList(List<Task> tasks) async {
    try {
      await DatabaseProvider.addTasksList(tasks);
    } catch (e) {
      //TODO handle exception
      rethrow;
    }
  }
}
