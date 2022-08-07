import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/bloc/task/task_cubit.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/utils/const.dart';

class CustomFlexibleSpace extends StatelessWidget {
  final double maxHeight = 150.0;
  final double minHeight = 50.0;

  const CustomFlexibleSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
      return LayoutBuilder(
        builder: (context, constraints) {
          var expandRatio = _calculateExpandRatio(constraints);
          var animation = AlwaysStoppedAnimation(expandRatio);
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: Tween<double>(
                    begin: 0,
                    end: 16,
                  ).evaluate(animation),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Tween<double>(
                          begin: 0,
                          end: 24,
                        ).evaluate(animation),
                      ),
                      child: Align(
                        alignment: AlignmentGeometryTween(
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomCenter,
                        ).evaluate(animation)!,
                        child: Container(
                          width: Tween<double>(
                            begin: width,
                            end: width * 0.9 - 48.0,
                          ).evaluate(animation),
                          margin: EdgeInsets.only(
                            left: Tween<double>(
                              begin: 16.0,
                              end: 36.0,
                            ).evaluate(animation),
                          ),
                          child: Text(
                            S.current.myTasks,
                            style: TextStyle(
                              fontSize: Tween<double>(begin: 20, end: 36)
                                  .evaluate(animation),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentGeometryTween(
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomCenter,
                      ).evaluate(animation)!,
                      child: Container(
                        width: Tween<double>(
                          begin: width,
                          end: width * 0.9 - 48.0,
                        ).evaluate(animation),
                        margin: EdgeInsets.only(
                          left: Tween<double>(
                            begin: 16.0,
                            end: 36.0,
                          ).evaluate(animation),
                        ),
                        child: Opacity(
                          opacity: 1 - ((1 - animation.value) * 2.5) <= 0
                              ? 0
                              : 1 - ((1 - animation.value) * 2.5),
                          child: Text(
                            S.current.doneAmount(
                              state.tasks.where((e) => e.done).length,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(color: Const.kLightGray),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: context.read<TaskCubit>().changeDisplayCompleted,
                    icon: Image.asset(
                      state.displayCompleted
                          ? 'assets/images/visibility.png'
                          : 'assets/images/visibility_off.png',
                      height: state.displayCompleted ? 15.0 : 19.0,
                      color: Const.kBlue,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.biggest.height - minHeight) / (maxHeight - minHeight);
    return expandRatio;
  }
}
