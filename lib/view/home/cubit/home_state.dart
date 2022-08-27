part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required List<Task> tasks,
    required List<Task> displayTasks,
    @Default(ErrorType.none) ErrorType errorType,
    @Default(0) int completedAmount,
    @Default(true) bool displayCompleted,
    @Default(true) bool shouldShowError,
    @Default(0) int errorsInRowAmount,
  }) = _HomeState;
}
