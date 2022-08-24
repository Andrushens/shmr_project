import 'package:flutter/material.dart';
import 'package:shmr/generated/l10n.dart';

class CustomFlexibleSpace extends StatelessWidget {
  const CustomFlexibleSpace({
    required this.displayCompleted,
    required this.completedAmount,
    required this.onDisplayCompletedUpdate,
    super.key,
  });

  int get maxHeight => 150;
  double get minHeight => 50;
  final bool displayCompleted;
  final int completedAmount;
  final void Function({required bool displayCompleted})
      onDisplayCompletedUpdate;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);
        return ColoredBox(
          color: ColorTween(
            begin: Theme.of(context).colorScheme.background,
            end: Theme.of(context).scaffoldBackgroundColor,
          ).evaluate(animation)!,
          child: Stack(
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
                              begin: 16,
                              end: 36,
                            ).evaluate(animation),
                          ),
                          child: Text(
                            S.current.myTasks,
                            style: TextStyleTween(
                              begin: Theme.of(context).textTheme.subtitle2,
                              end: Theme.of(context).textTheme.subtitle1,
                            ).evaluate(animation),
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
                            begin: 16,
                            end: 36,
                          ).evaluate(animation),
                        ),
                        child: Opacity(
                          opacity: 1 - ((1 - animation.value) * 2.5) <= 0
                              ? 0
                              : 1 - ((1 - animation.value) * 2.5),
                          child: Text(
                            S.current.doneAmount(completedAmount),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () => onDisplayCompletedUpdate(
                      displayCompleted: !displayCompleted,
                    ),
                    icon: Image.asset(
                      displayCompleted
                          ? 'assets/images/visibility.png'
                          : 'assets/images/visibility_off.png',
                      height: displayCompleted ? 15.0 : 19.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    final expandRatio =
        (constraints.biggest.height - minHeight) / (maxHeight - minHeight);
    return expandRatio;
  }
}
