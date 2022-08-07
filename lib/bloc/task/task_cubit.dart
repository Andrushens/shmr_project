import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shmr/data/data_source/local_source.dart';
import 'package:shmr/data/data_source/remote_source.dart';
import 'package:shmr/data/repository/tasks_repository.dart';
import 'package:shmr/model/task/task.dart';
import 'package:uuid/uuid.dart';

part 'task_state.dart';
part 'task_cubit.freezed.dart';

class TaskCubit extends Cubit<TaskState> {
  late final TasksRepository tasksRepository;

  TaskCubit()
      : super(const TaskState(
          tasks: [],
          displayCompleted: true,
        )) {
    tasksRepository = TasksRepositoryImpl(
      remoteSource: RemoteSourceImpl(),
      localSource: LocalSourceImpl(),
    );
  }

  Future<void> initTasks() async {
    (await tasksRepository.fetchTasks()).fold(
      (failure) {
        //TODO emit error state
      },
      (tasks) {
        emit(state.copyWith(tasks: tasks));
      },
    );
  }

  void changeDisplayCompleted() {
    emit(state.copyWith(displayCompleted: !state.displayCompleted));
  }

  Future<void> addTask({Task? task, String? value}) async {
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
    emit(state.copyWith(tasks: tasks));
    await tasksRepository.addTask(newTask);
  }

  Future<void> deleteTask(String id) async {
    var tasks = List<Task>.from(state.tasks)..removeWhere((e) => e.id == id);
    emit(state.copyWith(tasks: tasks));
    await tasksRepository.deleteTask(id);
  }

  Future<void> updateTask(Task task) async {
    var indexToUpdate = state.tasks.indexWhere((e) => e.id == task.id);
    var tasks = List<Task>.from(state.tasks);
    tasks[indexToUpdate] = task;
    emit(state.copyWith(tasks: tasks));
    await tasksRepository.updateTask(task);
  }

  Future<void> updateTaskDone(String id, bool done) async {
    var task = state.tasks.firstWhere((e) => e.id == id);
    var updatedTask = task.copyWith(done: done);
    updateTask(updatedTask);
  }
}
