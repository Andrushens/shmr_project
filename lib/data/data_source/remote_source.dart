import 'package:dio/dio.dart';
import 'package:shmr/model/task/task.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/utils/failure.dart';
import 'package:shmr/utils/logger_interceptor.dart';

abstract class RemoteSource {
  Future<List<Task>> fetchTasks();
  Future<void> addTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> updateTask(Task task);
}

class RemoteSourceImpl implements RemoteSource {
  RemoteSourceImpl() {
    dio = Dio(
      BaseOptions(
        baseUrl: ConstRemote.baseUrl,
        headers: ConstRemote.baseHeaders,
        receiveTimeout: ConstRemote.receiveTimeout,
        sendTimeout: ConstRemote.sendTimeout,
      ),
    )..interceptors.add(LoggingInterceptor());
  }

  late final Dio dio;

  @override
  Future<List<Task>> fetchTasks() async {
    try {
      final response = await dio.get(ConstRemote.fetchTasksPath);
      final data = response.data as Map<String, dynamic>;
      if (data[ConstRemote.statusField] == 'ok') {
        final revision = data[ConstRemote.revisionField];
        dio.options.headers[ConstRemote.revisionHeader] = revision;
        final jsonList = data[ConstRemote.listField] as List<dynamic>;
        final tasks = <Task>[];
        for (final json in jsonList) {
          tasks.add(Task.fromJson(json as Map<String, Object?>));
        }
        return tasks;
      } else {
        throw ServerException();
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      final response = await dio.post(
        ConstRemote.addTaskPath,
        data: {
          ConstRemote.elementField: task.toJson(),
        },
      );
      final data = response.data as Map<String, dynamic>;
      if (data[ConstRemote.statusField] == 'ok') {
        final revision = data[ConstRemote.revisionField];
        dio.options.headers[ConstRemote.revisionHeader] = revision;
      } else {
        throw ServerException();
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final response = await dio.delete(
        ConstRemote.deleteTaskPath(id),
      );
      final data = response.data as Map<String, dynamic>;
      if (data[ConstRemote.statusField] == 'ok') {
        final revision = data[ConstRemote.revisionField];
        dio.options.headers[ConstRemote.revisionHeader] = revision;
      } else {
        throw ServerException();
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      final response = await dio.put(
        ConstRemote.updateTaskPath(task.id),
        data: {
          ConstRemote.elementField: task.toJson(),
        },
      );
      final data = response.data as Map<String, dynamic>;
      if (data[ConstRemote.statusField] == 'ok') {
        final revision = data[ConstRemote.revisionField];
        dio.options.headers[ConstRemote.revisionHeader] = revision;
      } else {
        throw ServerException();
      }
    } catch (error) {
      rethrow;
    }
  }
}
