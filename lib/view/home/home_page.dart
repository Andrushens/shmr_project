import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/data/repository/tasks_repository.dart';
import 'package:shmr/service/navigation/constants.dart';
import 'package:shmr/service/navigation/navigation_service.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';
import 'package:shmr/view/home/widgets/custom_flexible_space.dart';
import 'package:shmr/view/home/widgets/home_task_text_field.dart';
import 'package:shmr/view/home/widgets/tasks_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(
        tasksRepository: context.read<TasksRepository>(),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: ConstStyles.kBackPrimary,
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
                            expandedHeight: 150,
                            pinned: true,
                            backgroundColor: ConstStyles.kBackPrimary,
                            flexibleSpace: CustomFlexibleSpace(
                              displayCompleted: state.displayCompleted,
                              completedAmount: state.completedAmount,
                              onDisplayCompletedUpdate: context
                                  .read<HomeCubit>()
                                  .changeDisplayCompleted,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    offset: const Offset(-1, 0),
                                    color: Colors.black.withOpacity(.2),
                                    blurRadius: 1,
                                  ),
                                  BoxShadow(
                                    offset: const Offset(1, 0),
                                    color: Colors.black.withOpacity(.2),
                                    blurRadius: 1,
                                  ),
                                  BoxShadow(
                                    offset: const Offset(0, 1),
                                    color: Colors.black.withOpacity(.2),
                                    blurRadius: 1,
                                  ),
                                  const BoxShadow(
                                    offset: Offset(0, -1),
                                    color: Colors.white,
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Column(
                                  children: [
                                    TasksListView(tasks: state.displayTasks),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        left: 54,
                                        right: 64,
                                        bottom: 18,
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
                NavigationService.of(context).navigateTo(Routes.taskPage);
              },
              child: Image.asset(
                'assets/images/add.png',
                color: Colors.white,
                height: 14,
              ),
            ),
          );
        },
      ),
    );
  }
}
