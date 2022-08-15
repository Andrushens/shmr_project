part of 'task_cubit.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState({
    required Task? task,
    required int? deadline,
    required Importance importance,
    required String text,
    @Default(false) bool isEditingComplete,
  }) = _TaskState;
}
