import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/consit.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/reusabel_widget.dart';

class Task_Screen extends StatefulWidget {
  @override
  _Task_ScreenState createState() => _Task_ScreenState();
}

class _Task_ScreenState extends State<Task_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return taskbuilder(tasks: tasks);
      },
    );
  }
}
