

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/Archived_tasks.dart';
import 'package:todo_app/modules/done_tasks.dart';
import 'package:todo_app/modules/new_tasks.dart';
import 'package:todo_app/shared/states.dart';
import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isBottomSheetShown = false;
  IconData floatIcon = Icons.edit;

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Widget> screens = [
    New_tasks(),
    Done_tasks(),
    Archived_tasks(),
  ];
  late Database database;
  int currentIndex = 0;
  List <Map> newTasks = [];
  List <Map> doneTasks = [];
  List <Map> archivedTasks = [];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  void changeBottomSheetState({
    required bool isshow,
    required IconData icon,
  }) {
    isBottomSheetShown = isshow;
    floatIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print('database created');
          database.execute(
              'CREATE TABLE tasks ( id INTEGER PRIMARY KEY , title TEXT  , time TEXT , date TEXT, status TEXT)')
              .then((value) {
            print('table created');
          }).catchError((error) {
            print('Error happend : ${error.toString()}');
          });
        }, onOpen: (database) {
          getDataFromDB(database);
          print('database opened');
        }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO tasks (title , time, date, status) VALUES ("$title","$time","$date","New")')
          .then((value) {
        print('raw is inserted of $value');
        getDataFromDB(database);
        emit(AppInsertDatabaseState());
      }).catchError((error) {
        print(' ${error.toString()} happened');
      });
    });
  }

  void getDataFromDB(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'New') {
          newTasks.add(element);
        } else if (element['status'] == 'Done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }


  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDB(database);
      emit(AppUpdateDatabaseState());
    });
  }


  void deleteData({
    required int id,
  }) async {
    database.rawUpdate(
        'DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {
      getDataFromDB(database);
      emit(AppDeleteDatabaseState());
    });
  }
}