import 'package:flutter/material.dart';
import 'package:shmr/model/importance.dart';
import 'package:shmr/model/task/task.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/utils/date_formatter.dart';
import 'package:shmr/view/task/task_page.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(String id, bool value) onDoneUpdate;
  final Function(String id) onDelete;
  final Function(Task task) onUpdate;

  const TaskTile({
    required this.task,
    required this.onDoneUpdate,
    required this.onDelete,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = task.deadline != null
        ? DateTime.fromMillisecondsSinceEpoch(task.deadline!)
        : null;
    return Dismissible(
      key: ObjectKey(task),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete(task.id);
        } else {
          onDoneUpdate(task.id, !task.done);
        }
      },
      secondaryBackground: Container(
        padding: const EdgeInsets.only(right: 24.0),
        color: Const.kRed,
        alignment: Alignment.centerRight,
        child: Image.asset(
          'assets/images/delete.png',
          width: 19.0,
          height: 19.0,
          color: Colors.white,
        ),
      ),
      background: Container(
        padding: const EdgeInsets.only(left: 24.0),
        color: Const.kGreen,
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/images/check.png',
          width: 19.0,
          height: 19.0,
          color: Colors.white,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 20.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22.0,
              height: 22.0,
              child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor:
                      importanceFromString(task.importance) == Importance.high
                          ? Theme.of(context).errorColor
                          : Const.kLightGray,
                ),
                child: Checkbox(
                  activeColor: Const.kGreen,
                  value: task.done,
                  onChanged: (val) {
                    onDoneUpdate(task.id, val!);
                  },
                ),
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return TaskPage(
                          task: task,
                          onDelete: onDelete,
                          onUpdate: onUpdate,
                        );
                      },
                    ),
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
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text(
                              '!!',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    color: task.done
                                        ? Const.kLightGray
                                        : Theme.of(context)
                                            .unselectedWidgetColor,
                                  ),
                            ),
                          ),
                        } else if (importanceFromString(task.importance) ==
                            Importance.low) ...{
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 4.0,
                              top: 4.0,
                            ),
                            child: Image.asset(
                              'assets/images/arrow_down.png',
                              width: 10.0,
                              color: task.done ? Const.kLightGray : Const.kGray,
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
                                  color: task.done ? Const.kLightGray : null,
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
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          DateFormatter.formatDate(date),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Const.kLightGray),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14.0),
            SizedBox(
              width: 20.0,
              height: 20.0,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return TaskPage(
                          task: task,
                          onDelete: onDelete,
                          onUpdate: onUpdate,
                        );
                      },
                    ),
                  );
                },
                icon: Image.asset(
                  'assets/images/info_outline.png',
                  height: 20.0,
                  color: Const.kLightGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
