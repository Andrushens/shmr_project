import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';
import 'package:shmr/core/setup_locator.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';
import 'package:shmr/view/home/widgets/custom_flexible_space.dart';
import 'package:shmr/view/home/widgets/home_task_text_field.dart';
import 'package:shmr/view/home/widgets/tasks_list_view.dart';
import 'package:shmr/view/theme/theme_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _taskTextController;

  @override
  void initState() {
    super.initState();
    _taskTextController = TextEditingController();
    ShakeDetector.autoStart(
      onPhoneShake: () async {
        await context.read<ThemeCubit>().changeTheme();
      },
      shakeCountResetTime: 500,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _taskTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => locator<HomeCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
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
                            backgroundColor: Colors.transparent,
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
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                8,
                                0,
                                8,
                                8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    offset: const Offset(0, 2),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ColoredBox(
                                  color: Theme.of(context).colorScheme.surface,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TasksListView(tasks: state.displayTasks),
                                      const Padding(
                                        padding: EdgeInsetsDirectional.only(
                                          start: 54,
                                          end: 64,
                                          bottom: 18,
                                        ),
                                        child: HomeTaskTextField(),
                                      ),
                                    ],
                                  ),
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
              onPressed: () async {
                await context.read<HomeCubit>().navigateToTaskPage();
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
