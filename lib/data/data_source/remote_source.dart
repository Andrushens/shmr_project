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
        baseUrl: 'https://beta.mrdekk.ru/todobackend/',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer Taixpool',
        },
        receiveTimeout: 16000,
        sendTimeout: 16000,
      ),
    )..interceptors.add(LoggingInterceptor());
  }

  late final Dio dio;

  @override
  Future<List<Task>> fetchTasks() async {
    try {
      final response = await dio.get('list');
      final data = response.data as Map<String, dynamic>;
      if (response.statusCode == 200 && data['status'] == 'ok') {
        final revision = data['revision'];
        logger.i('revision: $revision');
        dio.options.headers['X-Last-Known-Revision'] = revision;
        final jsonList = data['list'] as List<dynamic>;
        final tasks = <Task>[];
        for (final json in jsonList) {
          tasks.add(Task.fromJson(json as Map<String, Object?>));
        }
        return tasks;
      }
      throw ServerException();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      final response = await dio.post(
        'list',
        data: {
          'element': task.toJson(),
        },
      );
      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'ok') {
        final revision = data['revision'];
        dio.options.headers['X-Last-Known-Revision'] = revision;
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
        'list/$id',
      );
      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'ok') {
        final revision = data['revision'];
        dio.options.headers['X-Last-Known-Revision'] = revision;
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
        'list/${task.id}',
        data: {
          'element': task.toJson(),
        },
      );
      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'ok') {
        final revision = data['revision'];
        dio.options.headers['X-Last-Known-Revision'] = revision;
      } else {
        throw ServerException();
      }
    } catch (error) {
      rethrow;
    }
  }
}
