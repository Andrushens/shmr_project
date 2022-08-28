import 'package:dartz/dartz.dart' show Either, Right;
import 'package:shmr/domain/model/failure.dart';
import 'package:shmr/domain/model/task/task.dart';
import 'package:shmr/domain/repository/tasks/tasks_repository.dart';

const mockTasks = <Task>[
  Task(
    id: '1',
    text: 'task-1',
    importance: 'basic',
    done: true,
    createdAt: 0,
    changedAt: 0,
    lastUpdatedBy: '1',
  ),
  Task(
    id: '2',
    text: 'task-2',
    importance: 'low',
    done: false,
    createdAt: 0,
    changedAt: 0,
    lastUpdatedBy: '1',
  ),
];

class MockTasksRepositoryImpl implements TasksRepository {
  @override
  Future<Either<Failure, bool>> addTask(Task task) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return const Right(true);
  }

  @override
  Future<Either<Failure, List<Task>>> fetchTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return const Right(mockTasks);
  }

  @override
  Future<Either<Failure, bool>> updateTask(Task task) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return const Right(true);
  }
}
