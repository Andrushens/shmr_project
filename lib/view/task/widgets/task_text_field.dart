import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/view/task/cubit/task_cubit.dart';

class TaskTextField extends StatefulWidget {
  const TaskTextField({
    required this.initialText,
    super.key,
  });

  final String? initialText;

  @override
  State<TaskTextField> createState() => _TaskTextFieldState();
}

class _TaskTextFieldState extends State<TaskTextField> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).shadowColor,
            offset: const Offset(0, 2),
            blurRadius: 1,
          ),
        ],
      ),
      margin: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 28),
      child: TextField(
        controller: textController,
        onChanged: context.read<TaskCubit>().updateTaskText,
        minLines: 3,
        maxLines: 24,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: S.current.whatToDo,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Theme.of(context).hintColor),
        ),
      ),
    );
  }
}
