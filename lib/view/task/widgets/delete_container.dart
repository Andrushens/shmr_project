import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/task/cubit/task_cubit.dart';

class DeleteContainer extends StatelessWidget {
  final bool isAvailable;

  const DeleteContainer({
    required this.isAvailable,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAvailable
          ? () {
              context.read<TaskCubit>().deleteTask();
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
              color: isAvailable ? Const.kRed : Const.kLightGray,
            ),
            const SizedBox(width: 14.0),
            Text(
              S.current.delete,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: isAvailable ? Const.kRed : Const.kLightGray,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
