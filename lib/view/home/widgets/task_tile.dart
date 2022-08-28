import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/core/setup_locator.dart';
import 'package:shmr/domain/model/importance.dart';
import 'package:shmr/domain/model/task/task.dart';
import 'package:shmr/service/navigation/constants.dart';
import 'package:shmr/service/navigation/navigation_service.dart';
import 'package:shmr/utils/date_formatter.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';

class TaskTile extends StatelessWidget {
  TaskTile({
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
  final _navigationService = locator<NavigationService>();

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
        padding: const EdgeInsetsDirectional.only(end: 24),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: Image.asset(
          'assets/images/delete.png',
          width: 19,
          height: 19,
          color: Colors.white,
        ),
      ),
      background: Container(
        padding: const EdgeInsetsDirectional.only(start: 24),
        color: Theme.of(context).selectedRowColor,
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/images/check.png',
          width: 19,
          height: 19,
          color: Colors.white,
        ),
      ),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 14, 20, 14),
        color: Theme.of(context).colorScheme.surface,
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
                          ? Theme.of(context).colorScheme.surfaceVariant
                          : Theme.of(context).hintColor,
                ),
                child: Checkbox(
                  activeColor: Theme.of(context).selectedRowColor,
                  checkColor: Theme.of(context).primaryColor,
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
                onTap: () {
                  _navigationService
                      .navigateTo(Routes.taskPage, data: task)
                      .then(
                    (updatedTask) {
                      context.read<HomeCubit>().handleTaskPagePop(updatedTask);
                    },
                  );
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
                            padding: const EdgeInsetsDirectional.only(end: 4),
                            child: Text(
                              '!!',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    color: task.done
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                  ),
                            ),
                          ),
                        } else if (importanceFromString(task.importance) ==
                            Importance.low) ...{
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                              end: 4,
                              top: 4,
                            ),
                            child: Image.asset(
                              'assets/images/arrow_down.png',
                              width: 10,
                              color: task.done
                                  ? Theme.of(context).hintColor
                                  : Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        },
                        Expanded(
                          child: Text(
                            task.text,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: task.done
                                          ? Theme.of(context).hintColor
                                          : null,
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
                        padding: const EdgeInsetsDirectional.only(top: 4),
                        child: Text(
                          DateFormatter.formatDate(date),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Theme.of(context).hintColor),
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
                padding: EdgeInsetsDirectional.zero,
                onPressed: () {
                  _navigationService
                      .navigateTo(Routes.taskPage, data: task)
                      .then(
                    (updatedTask) {
                      context.read<HomeCubit>().handleTaskPagePop(updatedTask);
                    },
                  );
                },
                icon: Image.asset(
                  'assets/images/info_outline.png',
                  height: 20,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
