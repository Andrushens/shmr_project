import 'package:dartz/dartz.dart' show Either, Left, Right;
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
      final tasks = await remoteSource.fetchTasks();
      await localSource.addTasksList(tasks);
      return Right(tasks);
    } catch (e) {
      logger.w('failed to fetch tasks remote: $e');
    }
    try {
      final tasks = await localSource.fetchTasks();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addTask(Task task) async {
    try {
      await localSource.addTask(task);
      await remoteSource.addTask(task);
      return const Right(true);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    try {
      await localSource.deleteTask(id);
      await remoteSource.deleteTask(id);
      return const Right(true);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(Task task) async {
    try {
      await localSource.updateTask(task);
      await remoteSource.updateTask(task);
      return const Right(true);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
