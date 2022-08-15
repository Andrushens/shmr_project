import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/utils/date_formatter.dart';
import 'package:shmr/view/task/cubit/task_cubit.dart';

class DeadlineContainer extends StatelessWidget {
  const DeadlineContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deadline = context.select<TaskCubit, DateTime?>(
      (cubit) {
        var date = cubit.state.deadline;
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
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  DateFormatter.formatDate(deadline),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Const.kBlue),
                ),
              ),
          ],
        ),
        Switch(
          value: deadline != null,
          onChanged: (_) {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 700),
              ),
            ).then(
              (value) => context.read<TaskCubit>().updateDeadline(value),
            );
          },
          inactiveTrackColor: Colors.black.withOpacity(
            0.06,
          ),
        ),
      ],
    );
  }
}
