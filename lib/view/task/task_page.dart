import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/data/repository/tasks_repository.dart';
import 'package:shmr/model/task/task.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/task/cubit/task_cubit.dart';
import 'package:shmr/view/task/widgets/importance_popup_button.dart';
import 'package:shmr/view/task/widgets/deadline_container.dart';
import 'package:shmr/view/task/widgets/delete_container.dart';
import 'package:shmr/view/task/widgets/task_sliver_appbar.dart';
import 'package:shmr/view/task/widgets/task_text_field.dart';

class TaskPage extends StatelessWidget {
  final Task? task;

  const TaskPage({
    this.task,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Container(
            color: Const.kBackPrimary,
            child: BlocProvider(
              create: (context) => TaskCubit(initialTask: task),
              child: BlocListener<TaskCubit, TaskState>(
                listenWhen: ((previous, current) {
                  return previous.isEditingComplete !=
                          current.isEditingComplete &&
                      current.isEditingComplete;
                }),
                listener: (context, state) {
                  Navigator.of(context).pop(state.task);
                },
                child: CustomScrollView(
                  slivers: [
                    const TaskSliverAppBar(),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TaskTextField(initialText: task?.text),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                            child: ImportancePopupButton(),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                            child: DeadlineContainer(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: Divider(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 11.0,
                            ),
                            child: DeleteContainer(
                              isAvailable: task != null,
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
        ),
      ),
    );
  }
}
