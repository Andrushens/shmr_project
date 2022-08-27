import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:shmr/data/data_source/local_source.dart';
import 'package:shmr/data/data_source/remote_source.dart';
import 'package:shmr/model/failure.dart';
import 'package:shmr/model/task/task.dart';
import 'package:shmr/service/connecitivty_status_provider.dart';
import 'package:shmr/utils/const.dart';
import 'package:sqflite/sqlite_api.dart';

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
    required this.connectivityProvider,
  });

  final RemoteSource remoteSource;
  final LocalSource localSource;
  final ConnectivityProvider connectivityProvider;

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
    } catch (_) {
      logger.w('failed to fetch tasks remote');
    }
    try {
      final tasksMaps = await localSource.fetchTasks();
      final tasks = tasksMaps.map(Task.fromJson).toList();
      return Right(tasks);
    } catch (e) {
      logger.w('failed to fetch tasks local: $e');
      return const Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addTask(Task task) async {
    try {
      await localSource.addTask(task.toJson());
      await remoteSource.addTask(task.toJson());
      return const Right(true);
    } on ServerException catch (_) {
      logger.w('failed to add task remote');
      return const Left(ServerFailure());
    } on DatabaseException catch (e) {
      logger.w('failed to add task local: $e');
      return const Left(DatabaseFailure());
    } catch (e) {
      if (!(await connectivityProvider.isConnected)) {
        logger.w('failed to add task: Connectivity failure');
        return const Left(ConnectivityFailure());
      }
      logger.w('failed to add task');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    try {
      await localSource.deleteTask(id);
      await remoteSource.deleteTask(id);
      return const Right(true);
    } on ServerException catch (_) {
      logger.w('failed to delete task remote');
      return const Left(ServerFailure());
    } on DatabaseException catch (e) {
      logger.w('failed to delete task local: $e');
      return const Left(DatabaseFailure());
    } catch (e) {
      if (!(await connectivityProvider.isConnected)) {
        logger.w('failed to delete task: Connectivity failure');
        return const Left(ConnectivityFailure());
      }
      logger.w('failed to delete task');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(Task task) async {
    try {
      await localSource.updateTask(task.id, task.toJson());
      await remoteSource.updateTask(task.id, task.toJson());
      return const Right(true);
    } on ServerException catch (_) {
      logger.w('failed to update task remote');
      return const Left(ServerFailure());
    } on DatabaseException catch (e) {
      logger.w('failed to update task local: $e');
      return const Left(DatabaseFailure());
    } catch (e) {
      if (!(await connectivityProvider.isConnected)) {
        logger.w('failed to update task: Connectivity failure');
        return const Left(ConnectivityFailure());
      }
      logger.w('failed to update task');
      return const Left(ServerFailure());
    }
  }
}
