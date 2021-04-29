import 'package:flutter/material.dart';
import 'package:todo_app/archive_screen.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/done_screen.dart';
import 'package:todo_app/reusabel_widget.dart';
import 'package:todo_app/task_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'consit.dart';

class Home extends StatelessWidget {
  var scaffold_key = GlobalKey<ScaffoldState>();
  var form_key = GlobalKey<FormState>();
  var titlecontrol = TextEditingController();
  var timecontrol = TextEditingController();
  var datecontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..create_database(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffold_key,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.green,
              title: Text(cubit.Titels[cubit.current_index]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseloadingState,
              builder: (context) => cubit.Screens[cubit.current_index],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green,
                child: Icon(cubit.fabicon),
                onPressed: () {
                  if (cubit.isbottomsheetopen) {
                    if (form_key.currentState.validate()) {
                      cubit.insert_data(
                          title: titlecontrol.text,
                          time: timecontrol.text,
                          date: datecontrol.text);
                    }
                  } else {
                    scaffold_key.currentState
                        .showBottomSheet(
                          (context) => Container(
                            padding: EdgeInsets.all(20.0),
                            child: Form(
                              key: form_key,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  default_form(
                                      controller: titlecontrol,
                                      type: TextInputType.text,
                                      validate: (String value) {
                                        if (value.isEmpty) {
                                          return "title must not be null";
                                        }
                                        return null;
                                      },
                                      label: "task title",
                                      ontap: () {
                                        print("title");
                                      },
                                      prefix: Icons.title),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  default_form(
                                      controller: timecontrol,
                                      type: TextInputType.datetime,
                                      validate: (String value) {
                                        if (value.isEmpty) {
                                          return "timing must not be null";
                                        }
                                        return null;
                                      },
                                      label: "task time",
                                      ontap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timecontrol.text =
                                              value.format(context).toString();
                                          print(value.format(context));
                                        });
                                      },
                                      prefix: Icons.title),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  default_form(
                                    controller: datecontrol,
                                    type: TextInputType.datetime,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return "date must not be null";
                                      }
                                      return null;
                                    },
                                    label: "task date",
                                    ontap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2022-04-01'))
                                          .then((value) => datecontrol.text =
                                              DateFormat.yMMMd().format(value));
                                    },
                                    prefix: Icons.calendar_today,
                                  )
                                ],
                              ),
                            ),
                          ),
                          elevation: 20,
                        )
                        .closed
                        .then((value) => {
                              cubit.changeabottomcheetstate(
                                  isshow: false, icon: Icons.edit)
                            });
                    cubit.changeabottomcheetstate(
                        isshow: true, icon: Icons.add);
                  }
                }),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.current_index,
              selectedItemColor: Colors.green,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_rounded), label: "Achived")
              ],
            ),
          );
        },
      ),
    );
  }
}
