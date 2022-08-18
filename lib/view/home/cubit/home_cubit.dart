import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shmr/data/repository/tasks_repository.dart';
import 'package:shmr/model/task/task.dart';
import 'package:uuid/uuid.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  final TasksRepository tasksRepository;

  HomeCubit({required this.tasksRepository})
      : super(
          const HomeState(
            tasks: [],
            displayTasks: [],
            completedAmount: 0,
            displayCompleted: true,
          ),
        );

  Future<void> initTasks() async {
    (await tasksRepository.fetchTasks()).fold(
      (failure) {
        //TODO emit error state
      },
      (tasks) {
        var completedAmount = tasks.where((e) => e.done).length;
        var displayTasks = tasks
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

  void changeDisplayCompleted(bool displayCompleted) {
    var displayTasks = state.tasks
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
    var id = const Uuid().v4();
    var newTask = task ??
        Task(
          id: id,
          text: value ?? id,
          importance: 'basic',
          done: false,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          changedAt: 0,
          lastUpdatedBy: id,
        );
    var tasks = List<Task>.from(state.tasks)..add(newTask);
    var displayTasks = List<Task>.from(state.displayTasks)..add(newTask);
    emit(
      state.copyWith(
        tasks: tasks,
        displayTasks: displayTasks,
      ),
    );
    await tasksRepository.addTask(newTask);
  }

  Future<void> deleteTask(String id) async {
    var isDeleteDone = state.tasks.firstWhere((e) => e.id == id).done;
    var tasks = List<Task>.from(state.tasks)
      ..removeWhere(
        (e) => e.id == id,
      );
    var displayTasks = List<Task>.from(state.displayTasks)
      ..removeWhere(
        (e) => e.id == id,
      );
    var completedAmount = state.completedAmount - (isDeleteDone ? 1 : 0);
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
    var indexToUpdate = state.tasks.indexWhere(
      (e) => e.id == task.id,
    );
    var tasks = List<Task>.from(state.tasks);
    tasks[indexToUpdate] = task;
    var indexToUpdateDisplayed = state.displayTasks.indexWhere(
      (e) => e.id == task.id,
    );
    var displayTasks = List<Task>.from(state.displayTasks);
    var prevTask = displayTasks[indexToUpdateDisplayed];
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

  Future<void> updateTaskDone(String id, bool done) async {
    var task = state.tasks.firstWhere((e) => e.id == id);
    var updatedTask = task.copyWith(done: done);
    updateTask(updatedTask);
  }

  Future<void> handleTaskPagePop(Task? task) async {
    if (task == null) {
      return;
    }
    if (task.isDeleted) {
      return await deleteTask(task.id);
    }
    if (state.tasks.any((e) => e.id == task.id)) {
      return await updateTask(task);
    }
    return await createTask(task: task);
  }
}
