import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/task/cubit/task_cubit.dart';

class DeleteContainer extends StatelessWidget {
  const DeleteContainer({
    required this.isAvailable,
    super.key,
  });
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAvailable
          ? () {
              context.read<TaskCubit>().deleteTask();
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/delete.png',
              width: 16,
              color: isAvailable ? ConstStyles.kRed : ConstStyles.kLightGray,
            ),
            const SizedBox(width: 14),
            Text(
              S.current.delete,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color:
                        isAvailable ? ConstStyles.kRed : ConstStyles.kLightGray,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
