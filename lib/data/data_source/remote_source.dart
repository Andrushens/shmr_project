import 'package:dio/dio.dart';
import 'package:shmr/model/failure.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/utils/logger_interceptor.dart';
import 'package:shmr/utils/revision_interceptor.dart';

abstract class RemoteSource {
  Future<List<Map<String, dynamic>>> fetchTasks();
  Future<void> addTask(Map<String, dynamic> taskMap);
  Future<void> deleteTask(String id);
  Future<void> updateTask(String id, Map<String, dynamic> taskMap);
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
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await dio.get<Map<String, dynamic>>(
      ConstRemote.fetchTasksPath,
    );
    final data = response.data;
    if (data != null && data[ConstRemote.statusField] == 'ok') {
      final jsonList = data[ConstRemote.listField] as List<dynamic>;
      final resList = jsonList.map((e) => e as Map<String, dynamic>).toList();
      return resList;
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<void> addTask(Map<String, dynamic> taskMap) async {
    final response = await dio.post<Map<String, dynamic>>(
      ConstRemote.addTaskPath,
      data: {
        ConstRemote.elementField: taskMap,
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
  Future<void> updateTask(String id, Map<String, dynamic> taskMap) async {
    final response = await dio.put<Map<String, dynamic>>(
      ConstRemote.updateTaskPath(id),
      data: {
        ConstRemote.elementField: taskMap,
      },
    );
    final data = response.data;
    if (data == null || data[ConstRemote.statusField] != 'ok') {
      throw const ServerException();
    }
  }
}
