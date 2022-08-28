import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shmr/domain/model/importance.dart';
import 'package:shmr/domain/model/task/task.dart';
import 'package:shmr/domain/repository/tasks/mock_tasks_repository.dart';
import 'package:shmr/view/task/cubit/task_cubit.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('TaskCubit test', () {
    late TaskCubit taskCubitRaw;
    late Task mockInitialTask;
    late TaskCubit taskCubitInited;
    late Task mockCreatedTask;
    late int mockTimestamp;
    late DateTime mockDeadlineDate;
    late String mockText;
    late String mockId;
    late Importance mockImportance;

    setUp(() {
      mockId = const Uuid().v4();
      mockText = 'mockText';
      mockDeadlineDate = DateTime.now();
      mockTimestamp = DateTime.now().millisecondsSinceEpoch;
      mockImportance = Importance.high;
      mockInitialTask = mockTasks.first;
      mockCreatedTask = Task(
        id: mockId,
        text: mockText,
        deadline: mockDeadlineDate.millisecondsSinceEpoch,
        importance: stringFromImportance(mockImportance),
        done: false,
        createdAt: mockTimestamp,
        changedAt: 0,
        lastUpdatedBy: '1',
      );
      taskCubitInited = TaskCubit(initialTask: mockInitialTask);
      taskCubitRaw = TaskCubit(initialTask: null);
    });

    blocTest<TaskCubit, TaskState>(
      'TaskCubit withouth initial task updateTaskText, updateImportance, '
      'updateDeadline, createTask',
      build: () => taskCubitRaw,
      act: (cubit) async {
        cubit
          ..updateTaskText(mockText)
          ..updateDeadline(mockDeadlineDate)
          ..updateImportance(Importance.high)
          ..saveTask(timestamp: mockTimestamp, id: mockId);
      },
      expect: () {
        return [
          TaskState(
            deadline: null,
            importance: Importance.none,
            task: null,
            text: mockText,
          ),
          TaskState(
            deadline: mockDeadlineDate.millisecondsSinceEpoch,
            importance: Importance.none,
            task: null,
            text: mockText,
          ),
          TaskState(
            deadline: mockDeadlineDate.millisecondsSinceEpoch,
            importance: Importance.high,
            task: null,
            text: mockText,
          ),
          TaskState(
            deadline: mockDeadlineDate.millisecondsSinceEpoch,
            importance: Importance.high,
            task: mockCreatedTask,
            text: mockText,
            isEditingComplete: true,
          ),
        ];
      },
    );

    blocTest<TaskCubit, TaskState>(
      'TaskCubit with initial task saveTask',
      build: () => taskCubitInited,
      act: (cubit) async {
        cubit.saveTask(timestamp: mockTimestamp, id: mockId);
      },
      expect: () {
        return [
          TaskState(
            deadline: mockInitialTask.deadline,
            importance: importanceFromString(mockInitialTask.importance),
            task: mockInitialTask.copyWith(changedAt: mockTimestamp),
            text: mockInitialTask.text,
            isEditingComplete: true,
          ),
        ];
      },
    );

    tearDown(() {
      taskCubitInited.close();
    });
  });
}
