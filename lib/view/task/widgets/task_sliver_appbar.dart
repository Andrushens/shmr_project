import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/task/cubit/task_cubit.dart';

class TaskSliverAppBar extends StatelessWidget {
  const TaskSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ConstStyles.kBackPrimary,
      leading: IconButton(
        onPressed: () => context.read<TaskCubit>().completeEditing(task: null),
        icon: Image.asset(
          'assets/images/close.png',
          width: 16,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TextButton(
            onPressed: () {
              context.read<TaskCubit>().saveTask();
            },
            child: Text(
              S.current.save,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: ConstStyles.kBlue),
            ),
          ),
        ),
      ],
    );
  }
}