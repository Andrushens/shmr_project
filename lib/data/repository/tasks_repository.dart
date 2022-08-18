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
  final RemoteSource remoteSource;
  final LocalSource localSource;

  const TasksRepositoryImpl({
    required this.remoteSource,
    required this.localSource,
  });

  @override
  Future<Either<Failure, List<Task>>> fetchTasks() async {
    try {
      var tasks = await remoteSource.fetchTasks();
      await localSource.addTasksList(tasks);
      return Right(tasks);
    } catch (e) {
      logger.w('failed to fetch tasks remote: $e');
    }
    try {
      var tasks = await localSource.fetchTasks();
      return Right(tasks);
    } catch (e) {
      //TODO handle exception
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, bool>> addTask(Task task) async {
    try {
      await localSource.addTask(task);
      await remoteSource.addTask(task);
      return const Right(true);
    } on Failure {
      //TODO handle exception
      return Left(Failure());
    } catch (e) {
      //TODO handle exception
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    try {
      await localSource.deleteTask(id);
      await remoteSource.deleteTask(id);
      return const Right(true);
    } on Failure {
      //TODO handle exception
      return Left(Failure());
    } catch (e) {
      //TODO handle exception
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(Task task) async {
    try {
      await localSource.updateTask(task);
      await remoteSource.updateTask(task);
      return const Right(true);
    } on Failure {
      //TODO handle exception
      return Left(Failure());
    } catch (e) {
      //TODO handle exception
      return Left(Failure());
    }
  }
}
