import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';

import '../archive_screen.dart';
import '../consit.dart';
import '../done_screen.dart';
import '../task_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int current_index = 0;

  List<Widget> Screens = [
    Task_Screen(),
    Done_Screen(),
    Archive_Screen(),
  ];
  List<String> Titels = ['Task', 'Done', 'Archived'];
  void changeIndex(index) {
    current_index = index;
    emit(AppChangeNBPState());
  }

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void create_database() {
    openDatabase('todt.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT ,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print("table created");
      }).catchError((error) {
        print("error ${error.toString()}");
      });
      print("database created");
    }, onOpen: (database) {
      getdatafromdatabase(database);
      print("database opned");
    }).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insert_data({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        emit(AppInsertDataBaseState());
        getdatafromdatabase(database);
        print('$value inserted succefully');
      }).catchError((error) {
        print("error when inserted${error.toString()} ");
      });
      return null;
    });
  }

  void getdatafromdatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDataBaseloadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else
          archivedTasks.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

  void ubdateData({
    @required String status,
    @required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ? ', [
      '$status',
      id,
    ]).then((value) {
      getdatafromdatabase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void deletData({
    @required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getdatafromdatabase(database);
      emit(AppDeleteDataBaseState());
    });
  }

  bool isbottomsheetopen = false;
  IconData fabicon = Icons.edit;
  void changeabottomcheetstate({
    @required bool isshow,
    @required IconData icon,
  }) {
    isbottomsheetopen = isshow;
    fabicon = icon;
    emit(AppChangebottomsheetstate());
  }
}
