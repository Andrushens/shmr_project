part of 'task_cubit.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState({
    required List<Task> tasks,
    required bool displayCompleted,
  }) = _TaskState;
}
