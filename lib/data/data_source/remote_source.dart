import 'package:dio/dio.dart';
import 'package:shmr/domain/model/failure.dart';
import 'package:shmr/domain/model/task/task.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/utils/logger_interceptor.dart';
import 'package:shmr/utils/revision_interceptor.dart';

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
    );
    dio
      ..interceptors.add(RevisionInterceptor(dio))
      ..interceptors.add(LoggingInterceptor());
  }

  late final Dio dio;

  @override
  Future<List<Task>> fetchTasks() async {
    final response = await dio.get<Map<String, dynamic>>(
      ConstRemote.fetchTasksPath,
    );
    final data = response.data;
    if (data != null && data[ConstRemote.statusField] == 'ok') {
      final jsonList = data[ConstRemote.listField] as List<dynamic>;
      final resList = jsonList
          .map((e) => e as Map<String, dynamic>)
          .map(Task.fromJson)
          .toList();
      return resList;
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<void> addTask(Task task) async {
    final response = await dio.post<Map<String, dynamic>>(
      ConstRemote.addTaskPath,
      data: {
        ConstRemote.elementField: task.toJson(),
      },
    );
    final data = response.data;
    if (data == null || data[ConstRemote.statusField] != 'ok') {
      throw const ServerException();
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final response = await dio.delete<Map<String, dynamic>>(
      ConstRemote.deleteTaskPath(id),
    );
    final data = response.data;
    if (data == null || data[ConstRemote.statusField] != 'ok') {
      throw const ServerException();
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    final response = await dio.put<Map<String, dynamic>>(
      ConstRemote.updateTaskPath(task.id),
      data: {
        ConstRemote.elementField: task.toJson(),
      },
    );
    final data = response.data;
    if (data == null || data[ConstRemote.statusField] != 'ok') {
      throw const ServerException();
    }
  }
}
