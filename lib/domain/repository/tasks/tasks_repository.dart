import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:shmr/data/local/local_source.dart';
import 'package:shmr/data/remote/remote_source.dart';
import 'package:shmr/domain/model/failure.dart';
import 'package:shmr/domain/model/task/task.dart';
import 'package:shmr/service/analytics_provider.dart';
import 'package:shmr/service/connecitivty_status_provider.dart';
import 'package:shmr/service/shared_provider.dart';
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
    required this.analyticsProvider,
  });

  final RemoteSource remoteSource;
  final LocalSource localSource;
  final ConnectivityProvider connectivityProvider;
  final AnalyticsProvider analyticsProvider;

  @override
  Future<Either<Failure, List<Task>>> fetchTasks() async {
    try {
      final backendTasks = await remoteSource.fetchTasks();
      final dbTasks = await localSource.fetchTasks();
      if (dbTasks.isEmpty && backendTasks.isNotEmpty) {
        try {
          await localSource.saveTasks(backendTasks);
        } catch (e) {
          logger.w('failed to save tasks local: $e');
        }
      }
      final resTasks = mergeTasksLists(
        backendTasks: backendTasks,
        dbTasks: dbTasks,
      );

      final localRevision = SharedProvider.getLocalRevision();
      final remoteRevision = SharedProvider.getRemoteRevision();
      if (localRevision > remoteRevision) {
        await remoteSource.patchTasks(resTasks);
      }

      return Right(resTasks);
    } catch (_) {
      logger.w('failed to fetch tasks remote');
    }
    try {
      final dbTasks = await localSource.fetchTasks();
      return Right(dbTasks);
    } catch (e) {
      logger.w('failed to fetch tasks local: $e');
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addTask(Task task) async {
    try {
      await localSource.addTask(task);
      await remoteSource.addTask(task);
      await analyticsProvider.logEvent(AnalyticsEvent.createTask);
      return const Right(true);
    } on ServerException catch (e) {
      logger.w('failed to add task remote');
      await analyticsProvider.logErrorEvent(
        AnalyticsErrorEvent.createTaskError,
        data: e.toString(),
      );
      return Left(ServerFailure());
    } on DatabaseException catch (e) {
      logger.w('failed to add task local: $e');
      await analyticsProvider.logErrorEvent(
        AnalyticsErrorEvent.createTaskError,
        data: e.toString(),
      );
      return Left(DatabaseFailure());
    } catch (e) {
      if (!(await connectivityProvider.isConnected)) {
        logger.w('failed to add task: Connectivity failure');
        return Left(ConnectivityFailure());
      }
      logger.w('failed to add task');
      await analyticsProvider.logErrorEvent(
        AnalyticsErrorEvent.createTaskError,
        data: e.toString(),
      );
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    try {
      await localSource.deleteTask(id);
      await remoteSource.deleteTask(id);
      await analyticsProvider.logEvent(AnalyticsEvent.deleteTask);
      return const Right(true);
    } on ServerException catch (e) {
      logger.w('failed to delete task remote');
      await analyticsProvider.logErrorEvent(
        AnalyticsErrorEvent.deleteTaskError,
        data: e.toString(),
      );
      return Left(ServerFailure());
    } on DatabaseException catch (e) {
      logger.w('failed to delete task local: $e');
      await analyticsProvider.logErrorEvent(
        AnalyticsErrorEvent.deleteTaskError,
        data: e.toString(),
      );
      return Left(DatabaseFailure());
    } catch (e) {
      if (!(await connectivityProvider.isConnected)) {
        logger.w('failed to delete task: Connectivity failure');
        return Left(ConnectivityFailure());
      }
      logger.w('failed to delete task');
      await analyticsProvider.logErrorEvent(
        AnalyticsErrorEvent.deleteTaskError,
        data: e.toString(),
      );
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(Task task) async {
    try {
      await localSource.updateTask(task);
      await remoteSource.updateTask(task);
      await analyticsProvider.logEvent(AnalyticsEvent.updateTask);
      return const Right(true);
    } on ServerException catch (e) {
      logger.w('failed to update task remote');
      await analyticsProvider.logErrorEvent(
        AnalyticsErrorEvent.updateTaskError,
        data: e.toString(),
      );
      return Left(ServerFailure());
    } on DatabaseException catch (e) {
      logger.w('failed to update task local: $e');
      await analyticsProvider.logErrorEvent(
        AnalyticsErrorEvent.updateTaskError,
        data: e.toString(),
      );
      return Left(DatabaseFailure());
    } catch (e) {
      if (!(await connectivityProvider.isConnected)) {
        logger.w('failed to update task: Connectivity failure');
        return Left(ConnectivityFailure());
      }
      logger.w('failed to update task');
      await analyticsProvider.logErrorEvent(
        AnalyticsErrorEvent.updateTaskError,
        data: e.toString(),
      );
      return Left(ServerFailure());
    }
  }

  List<Task> mergeTasksLists({
    required List<Task> backendTasks,
    required List<Task> dbTasks,
  }) {
    final resTasks = <Task>[];
    for (final dbTask in dbTasks) {
      final backendTaskIndex = backendTasks.indexWhere(
        (e) => e.id == dbTask.id,
      );
      if (backendTaskIndex == -1 ||
          dbTask.changedAt > backendTasks[backendTaskIndex].changedAt) {
        resTasks.add(dbTask);
      } else {
        resTasks.add(backendTasks[backendTaskIndex]);
      }
    }
    if (dbTasks.isEmpty) {
      for (final backendTask in backendTasks) {
        if (dbTasks.indexWhere((e) => e.id == backendTask.id) == -1) {
          resTasks.add(backendTask);
        }
      }
    }
    return resTasks;
  }
}
