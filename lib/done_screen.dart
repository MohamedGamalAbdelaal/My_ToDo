import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'reusabel_widget.dart';

class Done_Screen extends StatefulWidget {
  @override
  _Done_ScreenState createState() => _Done_ScreenState();
}

class _Done_ScreenState extends State<Done_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return taskbuilder(tasks: tasks);
      },
    );
  }
}
