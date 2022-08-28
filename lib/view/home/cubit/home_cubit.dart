import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shmr/domain/model/error_type.dart';
import 'package:shmr/domain/model/failure.dart';
import 'package:shmr/domain/model/task/task.dart';
import 'package:shmr/domain/repository/tasks/tasks_repository.dart';
import 'package:uuid/uuid.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.tasksRepository})
      : super(
          const HomeState(
            tasks: [],
            displayTasks: [],
          ),
        );

  final TasksRepository tasksRepository;

  Future<void> initTasks() async {
    (await tasksRepository.fetchTasks()).fold(
      (_) {},
      (tasks) {
        final completedAmount = tasks.where((e) => e.done).length;
        final displayTasks = tasks
            .where((e) => !e.done || e.done == state.displayCompleted)
            .toList();
        emit(
          state.copyWith(
            tasks: tasks,
            completedAmount: completedAmount,
            displayTasks: displayTasks,
          ),
        );
      },
    );
  }

  void changeDisplayCompleted({required bool displayCompleted}) {
    final displayTasks = state.tasks
        .where((e) => !e.done || e.done == displayCompleted)
        .toList();
    emit(
      state.copyWith(
        displayCompleted: displayCompleted,
        displayTasks: displayTasks,
      ),
    );
  }

  Future<void> createTask({Task? task, String? value}) async {
    final id = const Uuid().v4();
    final newTask = task ??
        Task(
          id: id,
          text: value ?? id,
          importance: 'basic',
          done: false,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          changedAt: 0,
          lastUpdatedBy: id,
        );
    final tasks = List<Task>.from(state.tasks)..add(newTask);
    final displayTasks = List<Task>.from(state.displayTasks)..add(newTask);

    emit(
      state.copyWith(
        tasks: tasks,
        displayTasks: displayTasks,
        shouldShowError: false,
      ),
    );
    (await tasksRepository.addTask(newTask)).fold(
      _handleFailure,
      (_) {
        emit(
          state.copyWith(
            errorType: ErrorType.none,
            errorsInRowAmount: 0,
          ),
        );
      },
    );
  }

  Future<void> deleteTask(String id) async {
    final isDeleteDone = state.tasks.firstWhere((e) => e.id == id).done;
    final tasks = List<Task>.from(state.tasks)
      ..removeWhere(
        (e) => e.id == id,
      );
    final displayTasks = List<Task>.from(state.displayTasks)
      ..removeWhere(
        (e) => e.id == id,
      );
    final completedAmount = state.completedAmount - (isDeleteDone ? 1 : 0);

    emit(
      state.copyWith(
        tasks: tasks,
        completedAmount: completedAmount,
        displayTasks: displayTasks,
        shouldShowError: false,
      ),
    );
    (await tasksRepository.deleteTask(id)).fold(
      _handleFailure,
      (_) {
        emit(
          state.copyWith(
            errorType: ErrorType.none,
            errorsInRowAmount: 0,
          ),
        );
      },
    );
  }

  Future<void> updateTask(Task updatedTask) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    final task = updatedTask.copyWith(changedAt: now);
    final indexToUpdate = state.tasks.indexWhere(
      (e) => e.id == task.id,
    );
    final tasks = List<Task>.from(state.tasks);
    tasks[indexToUpdate] = task;
    final indexToUpdateDisplayed = state.displayTasks.indexWhere(
      (e) => e.id == task.id,
    );
    final displayTasks = List<Task>.from(state.displayTasks);
    final prevTask = displayTasks[indexToUpdateDisplayed];
    var completedAmount = state.completedAmount;
    if (prevTask.done != task.done) {
      if (task.done) {
        completedAmount++;
        if (!state.displayCompleted) {
          displayTasks.removeAt(indexToUpdateDisplayed);
        } else {
          displayTasks[indexToUpdateDisplayed] = task;
        }
      } else {
        completedAmount--;
        displayTasks[indexToUpdateDisplayed] = task;
      }
    } else {
      displayTasks[indexToUpdateDisplayed] = task;
    }

    emit(
      state.copyWith(
        tasks: tasks,
        displayTasks: displayTasks,
        completedAmount: completedAmount,
        shouldShowError: false,
      ),
    );
    (await tasksRepository.updateTask(task)).fold(
      _handleFailure,
      (_) {
        emit(
          state.copyWith(
            errorType: ErrorType.none,
            errorsInRowAmount: 0,
          ),
        );
      },
    );
  }

  Future<void> updateTaskDone(String id, {required bool done}) async {
    final task = state.tasks.firstWhere((e) => e.id == id);
    final updatedTask = task.copyWith(done: done);
    await updateTask(updatedTask);
  }

  Future<void> handleTaskPagePop(dynamic task) async {
    if (task is Task) {
      if (task.isDeleted) {
        return deleteTask(task.id);
      }
      if (state.tasks.any((e) => e.id == task.id)) {
        return updateTask(task);
      }
      return createTask(task: task);
    }
  }

  void _handleFailure(Failure failure) {
    final currentErrorsAmount = state.errorsInRowAmount + 1;
    final shouldShowError = currentErrorsAmount % 3 == 1;
    switch (failure.runtimeType) {
      case ServerFailure:
        emit(
          state.copyWith(
            errorType: ErrorType.server,
            errorsInRowAmount: currentErrorsAmount,
            shouldShowError: shouldShowError,
          ),
        );
        break;
      case ConnectivityFailure:
        emit(
          state.copyWith(
            errorType: ErrorType.connectivity,
            errorsInRowAmount: currentErrorsAmount,
            shouldShowError: shouldShowError,
          ),
        );
        break;
      case DatabaseFailure:
        emit(
          state.copyWith(
            errorType: ErrorType.database,
            errorsInRowAmount: currentErrorsAmount,
            shouldShowError: shouldShowError,
          ),
        );
        break;
      default:
    }
  }
}
