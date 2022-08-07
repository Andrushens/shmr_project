import 'package:flutter/material.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/model/importance.dart';
import 'package:shmr/model/task/task.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/utils/date_formatter.dart';
import 'package:uuid/uuid.dart';

class TaskPage extends StatefulWidget {
  final Task? task;
  final Function(String id)? onDelete;
  final Function(Task task)? onUpdate;
  final Function({required Task task})? onAdd;

  const TaskPage({
    this.task,
    this.onDelete,
    this.onUpdate,
    this.onAdd,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DateTime? date;
  Importance? importance;
  late String localizedImportance;
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      importance = importanceFromString(widget.task!.importance);
      if (widget.task?.deadline != null) {
        date = DateTime.fromMillisecondsSinceEpoch(widget.task!.deadline!);
      }
    } else {
      importance = Importance.none;
    }
    localizedImportance = localizedStringFromImportance(importance);
    textController = TextEditingController()..text = widget.task?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Container(
            color: Const.kBackPrimary,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Const.kBackPrimary,
                  leading: IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: Image.asset(
                      'assets/images/close.png',
                      width: 16.0,
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton(
                        onPressed: () {
                          if (textController.text.isEmpty) return;
                          if (widget.task != null) {
                            var task = widget.task!.copyWith(
                              text: textController.text,
                              importance: stringFromImportance(importance),
                              deadline: date?.millisecondsSinceEpoch,
                              changedAt: DateTime.now().millisecondsSinceEpoch,
                              lastUpdatedBy: '1',
                            );
                            widget.onUpdate!(task);
                          } else {
                            var task = Task(
                              id: const Uuid().v4(),
                              text: textController.text,
                              importance: stringFromImportance(importance),
                              done: false,
                              deadline: date?.millisecondsSinceEpoch,
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                              changedAt: 0,
                              lastUpdatedBy: '1',
                            );
                            widget.onAdd!(task: task);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          S.current.save,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Const.kBlue),
                        ),
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Const.kBackSecondary,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Const.kLightGray,
                              offset: Offset(0, 2),
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.fromLTRB(
                          16.0,
                          16.0,
                          16.0,
                          28.0,
                        ),
                        child: TextField(
                          controller: textController,
                          minLines: 3,
                          maxLines: 24,
                          style: Theme.of(context).textTheme.bodyText1,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            hintText: S.current.whatToDo,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Const.kLightGray),
                          ),
                        ),
                      ),
                      PopupMenuButton(
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            0.0,
                            16.0,
                            16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.current.importance,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                localizedImportance,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(color: Const.kLightGray),
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (context) {
                          return <PopupMenuEntry>[
                            PopupMenuItem(
                              child: Text(
                                S.current.no,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              onTap: () {
                                setState(() {
                                  importance = Importance.none;
                                  localizedImportance =
                                      localizedStringFromImportance(importance);
                                });
                              },
                            ),
                            PopupMenuItem(
                              child: Text(
                                S.current.low,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              onTap: () {
                                setState(() {
                                  importance = Importance.low;
                                  localizedImportance =
                                      localizedStringFromImportance(importance);
                                });
                              },
                            ),
                            PopupMenuItem(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 64.0,
                              ),
                              child: Text(
                                '!! ${S.current.important}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        color: Theme.of(context).errorColor),
                              ),
                              onTap: () {
                                setState(() {
                                  importance = Importance.high;
                                  localizedImportance =
                                      localizedStringFromImportance(importance);
                                });
                              },
                            ),
                          ];
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          16.0,
                          16.0,
                          0.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.current.completeTill,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                if (date != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      DateFormatter.formatDate(date!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(color: Const.kBlue),
                                    ),
                                  ),
                              ],
                            ),
                            Switch(
                              value: date != null,
                              onChanged: (_) async {
                                var pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 700),
                                  ),
                                );
                                setState(() {
                                  date = pickedDate;
                                });
                              },
                              inactiveTrackColor: Colors.black.withOpacity(
                                0.06,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 50.0, bottom: 11.0),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: InkWell(
                          onTap: widget.task != null
                              ? () {
                                  widget.onDelete!(widget.task!.id);
                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/delete.png',
                                  width: 16.0,
                                  color: widget.task != null
                                      ? Const.kRed
                                      : Const.kLightGray,
                                ),
                                const SizedBox(width: 14.0),
                                Text(
                                  S.current.delete,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        color: widget.task != null
                                            ? Const.kRed
                                            : Const.kLightGray,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
