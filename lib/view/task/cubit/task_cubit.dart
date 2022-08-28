import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shmr/domain/model/importance.dart';
import 'package:shmr/domain/model/task/task.dart';
import 'package:uuid/uuid.dart';

part 'task_state.dart';
part 'task_cubit.freezed.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit({
    required Task? initialTask,
  }) : super(
          TaskState(
            task: initialTask,
            importance: initialTask != null
                ? importanceFromString(initialTask.importance)
                : Importance.none,
            deadline: initialTask?.deadline,
            text: initialTask?.text ?? '',
          ),
        );

  void saveTask({int? timestamp, String? id}) {
    final task = state.task?.copyWith(
      text: state.text,
      importance: stringFromImportance(state.importance),
      deadline: state.deadline,
    );
    if (task is Task) {
      updateTask(task, timestamp: timestamp);
    } else {
      createTask(timestamp: timestamp, id: id);
    }
  }

  void createTask({int? timestamp, String? id}) {
    if (state.text.isNotEmpty) {
      final newTask = Task(
        id: id ?? const Uuid().v4(),
        text: state.text,
        deadline: state.deadline,
        importance: stringFromImportance(state.importance),
        done: false,
        createdAt: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        changedAt: 0,
        lastUpdatedBy: '1',
      );
      completeEditing(task: newTask);
    }
  }

  void updateTask(Task task, {int? timestamp}) {
    final updatedTask = task.copyWith(
      changedAt: timestamp ?? DateTime.now().millisecondsSinceEpoch,
    );
    completeEditing(task: updatedTask);
  }

  void deleteTask() {
    final deletedTask = state.task?.copyWith(isDeleted: true);
    completeEditing(task: deletedTask);
  }

  void updateImportance(Importance importance) {
    emit(state.copyWith(importance: importance));
  }

  void updateDeadline(DateTime? date) {
    emit(state.copyWith(deadline: date?.millisecondsSinceEpoch));
  }

  void updateTaskText(String text) {
    emit(state.copyWith(text: text));
  }

  void completeEditing({required Task? task}) {
    emit(
      state.copyWith(
        isEditingComplete: true,
        task: task,
      ),
    );
  }
}
