import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/bloc/task/task_cubit.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/home/widgets/custom_flexible_space.dart';
import 'package:shmr/view/home/widgets/task_tile.dart';
import 'package:shmr/view/task/task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController taskTextController;

  @override
  void initState() {
    super.initState();
    taskTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Const.kBackPrimary,
      body: SafeArea(
        child: FutureBuilder(
          future: context.read<TaskCubit>().initTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverAppBar(
                      expandedHeight: 150.0,
                      pinned: true,
                      backgroundColor: Const.kBackPrimary,
                      flexibleSpace: CustomFlexibleSpace(),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(8.0, 00.0, 8.0, 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              offset: const Offset(-1, 0),
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 1.0,
                            ),
                            BoxShadow(
                              offset: const Offset(1, 0),
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 1.0,
                            ),
                            BoxShadow(
                              offset: const Offset(0, 1),
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 1.0,
                            ),
                            const BoxShadow(
                              offset: Offset(0, -1),
                              color: Colors.white,
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: state.displayCompleted
                                    ? state.tasks.length
                                    : state.tasks
                                        .where((e) => e.done == false)
                                        .length,
                                itemBuilder: (context, index) {
                                  var task = state.displayCompleted
                                      ? state.tasks[index]
                                      : state.tasks
                                          .where((e) => e.done == false)
                                          .toList()[index];
                                  return TaskTile(
                                    task: task,
                                    onDoneUpdate: context
                                        .read<TaskCubit>()
                                        .updateTaskDone,
                                    onDelete:
                                        context.read<TaskCubit>().deleteTask,
                                    onUpdate:
                                        context.read<TaskCubit>().updateTask,
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 54.0,
                                  right: 64.0,
                                  bottom: 18.0,
                                ),
                                child: TextField(
                                  controller: taskTextController,
                                  keyboardType: TextInputType.text,
                                  onEditingComplete: () {
                                    if (taskTextController.text.isEmpty) {
                                      FocusScope.of(context).unfocus();
                                      return;
                                    }
                                    context.read<TaskCubit>().addTask(
                                          value: taskTextController.text,
                                        );
                                    taskTextController.clear();
                                    FocusScope.of(context).unfocus();
                                  },
                                  style: Theme.of(context).textTheme.bodyText1,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: S.current.newTask,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          color: Const.kLightGray,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var onAdd = context.read<TaskCubit>().addTask;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return TaskPage(onAdd: onAdd);
              },
            ),
          );
        },
        child: Image.asset(
          'assets/images/add.png',
          color: Colors.white,
          height: 14.0,
        ),
      ),
    );
  }
}
