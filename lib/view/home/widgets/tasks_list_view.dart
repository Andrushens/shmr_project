import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/domain/model/task/task.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';
import 'package:shmr/view/home/widgets/task_tile.dart';

class TasksListView extends StatelessWidget {
  const TasksListView({
    required this.tasks,
    super.key,
  });

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskTile(
          task: task,
          onDoneUpdate: context.read<HomeCubit>().updateTaskDone,
          onDelete: context.read<HomeCubit>().deleteTask,
        );
      },
    );
  }
}
