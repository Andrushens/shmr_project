import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/utils/date_formatter.dart';
import 'package:shmr/view/task/cubit/task_cubit.dart';

class DeadlineContainer extends StatelessWidget {
  const DeadlineContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final deadline = context.select<TaskCubit, DateTime?>(
      (cubit) {
        final date = cubit.state.deadline;
        if (date is int) {
          return DateTime.fromMillisecondsSinceEpoch(date);
        }
        return date;
      },
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.completeTill,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            if (deadline != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 4),
                child: Text(
                  DateFormatter.formatDate(deadline),
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ),
          ],
        ),
        Switch(
          activeColor: Theme.of(context).colorScheme.primary,
          value: deadline != null,
          onChanged: (_) async {
            final futureDate = showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 700),
              ),
            );
            context.read<TaskCubit>().updateDeadline(await futureDate);
          },
          thumbColor: MaterialStateProperty.all(
            deadline != null
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
          ),
          inactiveTrackColor: Theme.of(context).unselectedWidgetColor,
        ),
      ],
    );
  }
}
