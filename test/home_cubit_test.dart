import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shmr/domain/model/task/task.dart';
import 'package:shmr/domain/repository/tasks/mock_tasks_repository.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';

void main() {
  group('HomeCubit test', () {
    late HomeCubit homeCubit;
    late bool mockDisplayCompleted;
    late Task mockTask;
    late List<Task> mockTasksUpdated;
    late bool mockDone;
    late int mockTimestamp;

    setUp(() {
      mockDisplayCompleted = false;
      mockTask = mockTasks.last;
      mockDone = !mockTask.done;
      mockTasksUpdated = List<Task>.from(mockTasks);
      mockTimestamp = DateTime.now().millisecondsSinceEpoch;
      mockTasksUpdated[1] = mockTasks[1].copyWith(
        done: mockDone,
        changedAt: mockTimestamp,
      );
      final mockTasksRepository = MockTasksRepositoryImpl();
      homeCubit = HomeCubit(tasksRepository: mockTasksRepository);
    });

    blocTest<HomeCubit, HomeState>(
      'HomeCubit initTasks, changeDisplayCompleted',
      build: () => homeCubit,
      act: (cubit) async {
        await cubit.initTasks();
        cubit.changeDisplayCompleted(
          displayCompleted: mockDisplayCompleted,
        );
      },
      expect: () => [
        HomeState(
          tasks: mockTasks,
          displayTasks: mockTasks,
          completedAmount: mockTasks.where((e) => e.done).length,
        ),
        HomeState(
          tasks: mockTasks,
          displayCompleted: mockDisplayCompleted,
          displayTasks: mockTasks
              .where((e) => !e.done || e.done == mockDisplayCompleted)
              .toList(),
          completedAmount: mockTasks.where((e) => e.done).length,
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'HomeCubit createTask',
      build: () => homeCubit,
      act: (cubit) async {
        await cubit.createTask(task: mockTask);
      },
      expect: () => [
        HomeState(
          tasks: [mockTask],
          displayTasks: [mockTask],
          completedAmount: mockTask.done ? 1 : 0,
          shouldShowError: false,
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'HomeCubit initTasks, deleteTask',
      build: () => homeCubit,
      act: (cubit) async {
        await cubit.initTasks();
        await cubit.deleteTask(mockTask.id);
      },
      expect: () => [
        HomeState(
          tasks: mockTasks,
          displayTasks: mockTasks,
          completedAmount: mockTasks.where((e) => e.done).length,
        ),
        HomeState(
          tasks: mockTasks.where((e) => e.id != mockTask.id).toList(),
          displayTasks: mockTasks.where((e) => e.id != mockTask.id).toList(),
          completedAmount:
              mockTasks.where((e) => e.id != mockTask.id).toList().length,
          shouldShowError: false,
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'HomeCubit initTasks, updateTaskDone',
      build: () => homeCubit,
      act: (cubit) async {
        await cubit.initTasks();
        await cubit.updateTaskDone(
          mockTask.id,
          done: mockDone,
          timestamp: mockTimestamp,
        );
      },
      expect: () {
        return [
          HomeState(
            tasks: mockTasks,
            completedAmount: mockTasks.where((e) => e.done).length,
            displayTasks: mockTasks,
          ),
          HomeState(
            tasks: mockTasksUpdated,
            displayTasks: mockTasksUpdated,
            completedAmount: mockTasksUpdated.where((e) => e.done).length,
            shouldShowError: false,
          ),
        ];
      },
    );

    tearDown(() {
      homeCubit.close();
    });
  });
}
