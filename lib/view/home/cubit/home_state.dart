part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required List<Task> tasks,
    required List<Task> displayTasks,
    required int completedAmount,
    required bool displayCompleted,
  }) = _HomeState;
}
