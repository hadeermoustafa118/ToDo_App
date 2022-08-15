

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectes_work/shared/states.dart';
import 'package:sqflite/sqflite.dart';

import '../modules/Archived_tasks.dart';
import '../modules/done_tasks.dart';
import '../modules/new_tasks.dart';



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
    const New_tasks(),
   const  Done_tasks(),
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
          database.execute(
              'CREATE TABLE tasks ( id INTEGER PRIMARY KEY , title TEXT  , time TEXT , date TEXT, status TEXT)')
              .then((value) {
          }).catchError((error) {
          });
        }, onOpen: (database) {
          getDataFromDB(database);
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
        getDataFromDB(database);
        emit(AppInsertDatabaseState());
      }).catchError((error) {
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