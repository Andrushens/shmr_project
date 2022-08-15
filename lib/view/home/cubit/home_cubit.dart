import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shmr/data/repository/tasks_repository.dart';
import 'package:shmr/model/task/task.dart';
import 'package:uuid/uuid.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.tasksRepository})
      : super(
          const HomeState(
            tasks: [],
            displayTasks: [],
            completedAmount: 0,
            displayCompleted: true,
          ),
        );

  final TasksRepository tasksRepository;

  Future<void> initTasks() async {
    (await tasksRepository.fetchTasks()).fold(
      (failure) {},
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
      ),
    );
    await tasksRepository.addTask(newTask);
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
      ),
    );
    await tasksRepository.deleteTask(id);
  }

  Future<void> updateTask(Task task) async {
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
      ),
    );
    await tasksRepository.updateTask(task);
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
}
