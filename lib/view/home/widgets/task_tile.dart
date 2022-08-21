import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/model/importance.dart';
import 'package:shmr/model/task/task.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/utils/date_formatter.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.onDoneUpdate,
    required this.onDelete,
    required this.onUpdate,
    super.key,
  });

  final Task task;
  final Future<void> Function(String id, {required bool done}) onDoneUpdate;
  final Future<void> Function(String id) onDelete;
  final Future<void> Function(Task task) onUpdate;

  @override
  Widget build(BuildContext context) {
    final date = task.deadline != null
        ? DateTime.fromMillisecondsSinceEpoch(task.deadline!)
        : null;
    return Dismissible(
      key: ObjectKey(task),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete(task.id);
        } else {
          onDoneUpdate(task.id, done: !task.done);
        }
      },
      secondaryBackground: Container(
        padding: const EdgeInsets.only(right: 24),
        color: ConstStyles.kRed,
        alignment: Alignment.centerRight,
        child: Image.asset(
          'assets/images/delete.png',
          width: 19,
          height: 19,
          color: Colors.white,
        ),
      ),
      background: Container(
        padding: const EdgeInsets.only(left: 24),
        color: ConstStyles.kGreen,
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/images/check.png',
          width: 19,
          height: 19,
          color: Colors.white,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor:
                      importanceFromString(task.importance) == Importance.high
                          ? Theme.of(context).errorColor
                          : ConstStyles.kLightGray,
                ),
                child: Checkbox(
                  activeColor: ConstStyles.kGreen,
                  value: task.done,
                  onChanged: (val) {
                    onDoneUpdate(task.id, done: val!);
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await context.read<HomeCubit>().navigateToTaskPage(task);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (importanceFromString(task.importance) ==
                            Importance.high) ...{
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '!!',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    color: task.done
                                        ? ConstStyles.kLightGray
                                        : Theme.of(context)
                                            .unselectedWidgetColor,
                                  ),
                            ),
                          ),
                        } else if (importanceFromString(task.importance) ==
                            Importance.low) ...{
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 4,
                              top: 4,
                            ),
                            child: Image.asset(
                              'assets/images/arrow_down.png',
                              width: 10,
                              color: task.done
                                  ? ConstStyles.kLightGray
                                  : ConstStyles.kGray,
                            ),
                          ),
                        },
                        Expanded(
                          child: Text(
                            task.text,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                  color:
                                      task.done ? ConstStyles.kLightGray : null,
                                  decoration: task.done
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                          ),
                        ),
                      ],
                    ),
                    if (date != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormatter.formatDate(date),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: ConstStyles.kLightGray),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: 20,
              height: 20,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await context.read<HomeCubit>().navigateToTaskPage(task);
                },
                icon: Image.asset(
                  'assets/images/info_outline.png',
                  height: 20,
                  color: ConstStyles.kLightGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
