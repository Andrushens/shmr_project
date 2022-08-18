import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/task/cubit/task_cubit.dart';

class TaskTextField extends StatefulWidget {
  final String? initialText;
  const TaskTextField({
    required this.initialText,
    Key? key,
  }) : super(key: key);

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
        color: Const.kBackSecondary,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Const.kLightGray,
            offset: Offset(0, 2),
            blurRadius: 1.0,
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 28.0),
      child: TextField(
        controller: textController,
        onChanged: context.read<TaskCubit>().updateTaskText,
        minLines: 3,
        maxLines: 24,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: S.current.whatToDo,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Const.kLightGray),
        ),
      ),
    );
  }
}
