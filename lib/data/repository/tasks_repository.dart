import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:dio/dio.dart';
import 'package:shmr/data/data_source/local_source.dart';
import 'package:shmr/data/data_source/remote_source.dart';
import 'package:shmr/model/task/task.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/utils/failure.dart';

abstract class TasksRepository {
  Future<Either<Failure, List<Task>>> fetchTasks();
  Future<Either<Failure, bool>> addTask(Task task);
  Future<Either<Failure, bool>> deleteTask(String id);
  Future<Either<Failure, bool>> updateTask(Task task);
}

class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl({
    required this.remoteSource,
    required this.localSource,
  });

  final RemoteSource remoteSource;
  final LocalSource localSource;

  @override
  Future<Either<Failure, List<Task>>> fetchTasks() async {
    try {
      final tasksMaps = await remoteSource.fetchTasks();
      final tasks = tasksMaps.map(Task.fromJson).toList();
      try {
        await localSource.addTasksList(tasksMaps);
      } catch (e) {
        logger.w('failed to save tasks local: $e');
      }
      return Right(tasks);
    } on DioError catch (e) {
      logger.w('failed to fetch tasks remote: ${e.message}');
    } catch (e) {
      logger.w('failed to fetch tasks remote: $e');
    }
    try {
      final tasksMaps = await localSource.fetchTasks();
      final tasks = tasksMaps.map(Task.fromJson).toList();
      return Right(tasks);
    } catch (e) {
      logger.w('failed to fetch tasks local: $e');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addTask(Task task) async {
    try {
      await localSource.addTask(task.toJson());
      await remoteSource.addTask(task.toJson());
      return const Right(true);
    } on ServerException {
      return const Left(ServerFailure());
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    try {
      await localSource.deleteTask(id);
      await remoteSource.deleteTask(id);
      return const Right(true);
    } on ServerException {
      return const Left(ServerFailure());
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(Task task) async {
    try {
      await localSource.updateTask(task.id, task.toJson());
      await remoteSource.updateTask(task.id, task.toJson());
      return const Right(true);
    } on ServerException {
      return const Left(ServerFailure());
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
