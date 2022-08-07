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
  late final Dio dio;

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

  @override
  Future<List<Task>> fetchTasks() async {
    try {
      var response = await dio.get('list');
      var data = response.data;
      if (response.statusCode == 200 && data['status'] == 'ok') {
        var revision = data['revision'];
        logger.i('revision: $revision');
        dio.options.headers['X-Last-Known-Revision'] = revision;
        var jsonList = data['list'] as List;
        var tasks = <Task>[];
        for (var json in jsonList) {
          tasks.add(Task.fromJson(json));
        }
        return tasks;
      }
      throw Failure();
    } catch (error) {
      //TODO handle exception
      rethrow;
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      var response = await dio.post(
        'list',
        data: {
          'element': task.toJson(),
        },
      );
      if (response.data['status'] == 'ok') {
        var revision = response.data['revision'];
        dio.options.headers['X-Last-Known-Revision'] = revision;
      } else {
        throw Failure();
      }
    } catch (error) {
      //TODO handle exception
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      var response = await dio.delete(
        'list/$id',
      );
      if (response.data['status'] == 'ok') {
        var revision = response.data['revision'];
        dio.options.headers['X-Last-Known-Revision'] = revision;
      } else {
        throw Failure();
      }
    } catch (error) {
      //TODO handle exception
      rethrow;
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      var response = await dio.put(
        'list/${task.id}',
        data: {
          'element': task.toJson(),
        },
      );
      if (response.data['status'] == 'ok') {
        var revision = response.data['revision'];
        dio.options.headers['X-Last-Known-Revision'] = revision;
      } else {
        throw Failure();
      }
    } catch (error) {
      //TODO handle exception
      rethrow;
    }
  }
}
