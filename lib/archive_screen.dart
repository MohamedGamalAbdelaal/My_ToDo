import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'reusabel_widget.dart';

class Archive_Screen extends StatefulWidget {
  @override
  _Archive_ScreenState createState() => _Archive_ScreenState();
}

class _Archive_ScreenState extends State<Archive_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;
        return taskbuilder(tasks: tasks);
      },
    );
  }
}
