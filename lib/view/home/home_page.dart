import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/model/task/task.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';
import 'package:shmr/view/home/widgets/custom_flexible_space.dart';
import 'package:shmr/view/home/widgets/home_task_text_field.dart';
import 'package:shmr/view/home/widgets/task_tile.dart';
import 'package:shmr/view/home/widgets/tasks_list_view.dart';
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
  void dispose() {
    super.dispose();
    taskTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Const.kBackPrimary,
      body: SafeArea(
        child: FutureBuilder(
          future: context.read<HomeCubit>().initTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 150.0,
                      pinned: true,
                      backgroundColor: Const.kBackPrimary,
                      flexibleSpace: CustomFlexibleSpace(
                        displayCompleted: state.displayCompleted,
                        completedAmount: state.completedAmount,
                        onDisplayCompletedUpdate:
                            context.read<HomeCubit>().changeDisplayCompleted,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
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
                              TasksListView(tasks: state.tasks),
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 54.0,
                                  right: 64.0,
                                  bottom: 18.0,
                                ),
                                child: HomeTaskTextField(),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const TaskPage(task: null);
              },
            ),
          ).then(
            (task) async {
              await context.read<HomeCubit>().handleTaskPagePop(task);
            },
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
