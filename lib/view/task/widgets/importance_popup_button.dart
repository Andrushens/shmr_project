import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/model/importance.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/task/cubit/task_cubit.dart';

class ImportancePopupButton extends StatelessWidget {
  const ImportancePopupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final importance = context.select<TaskCubit, String>(
      (cubit) => localizedStringFromImportance(cubit.state.importance),
    );
    return PopupMenuButton(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.importance,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            importance,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Const.kLightGray),
          ),
        ],
      ),
      itemBuilder: (context) {
        return <PopupMenuEntry<Text>>[
          PopupMenuItem(
            child: Text(
              S.current.no,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              context.read<TaskCubit>().updateImportance(Importance.none);
            },
          ),
          PopupMenuItem(
            child: Text(
              S.current.low,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              context.read<TaskCubit>().updateImportance(Importance.low);
            },
          ),
          PopupMenuItem(
            padding: const EdgeInsets.only(
              left: 16,
              right: 64,
            ),
            child: Text(
              '!! ${S.current.important}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Theme.of(context).errorColor),
            ),
            onTap: () {
              context.read<TaskCubit>().updateImportance(Importance.high);
            },
          ),
        ];
      },
    );
  }
}
