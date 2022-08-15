import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';

class HomeTaskTextField extends StatefulWidget {
  const HomeTaskTextField({super.key});

  @override
  State<HomeTaskTextField> createState() => _HomeTaskTextFieldState();
}

class _HomeTaskTextFieldState extends State<HomeTaskTextField> {
  late final TextEditingController taskTextController;

  @override
  void initState() {
    super.initState();
    taskTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: taskTextController,
      keyboardType: TextInputType.text,
      onEditingComplete: () {
        if (taskTextController.text.isNotEmpty) {
          context.read<HomeCubit>().createTask(value: taskTextController.text);
          taskTextController.clear();
        }
        FocusScope.of(context).unfocus();
      },
      style: Theme.of(context).textTheme.bodyText1,
      maxLines: null,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: S.current.newTask,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Const.kLightGray),
      ),
    );
  }
}
