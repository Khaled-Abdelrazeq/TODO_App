import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Map> tasksNew = [];
  List<Map> tasksDone = [];
  List<Map> tasksArchive = [];
  List<Map> tasksToday = [];
  List<Map> tasksTodayPersonal = [];
  List<Map> tasksTodayBusiness = [];

  late Database database;

  void createDatabase() {
    openDatabase('TODO.db', version: 1, onCreate: (db, version) {
      print('Database Created!');
      db
          .execute('CREATE TABLE Tasks (id INTEGER PRIMARY KEY,'
              ' title TEXT, date TEXT, time TEXT, type TEXT, status TEXT)')
          .then((value) {
        print('Table Created!');
      }).catchError((e) {
        print('Error When Created Table ${e.toString()}');
      });
    }, onOpen: (db) {
      print('Database Opened!');

      // getDataFromDatabase(db);
      // getTodayTasks(db);
    }).then((value) {
      database = value;
      getDataFromDatabase(database);
      getTodayTasks(database);

      emit(AppDatabaseCreatedState());
    });
  }

  insertToDatabase(
      {required String taskTitle,
      required String type,
      required String time,
      required String date}) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert('INSERT INTO Tasks(title, date, time, type, status) '
              'VALUES("$taskTitle", "$date", "$time", "$type", "New")')
          .then((value) {
        print('$value  Inserted Successfully!');
        emit(AppDatabaseInsertedState());
        getDataFromDatabase(database);
        getTodayTasks(database);
      }).catchError((e) => print('Error when insert data ${e.toString()}'));
    });
  }

  void getDataFromDatabase(Database database) {
    tasksDone = [];
    tasksArchive = [];
    tasksNew = [];
    emit(AppDatabaseLoadingState());
    database.rawQuery('Select * From Tasks').then((value) {
      //tasksNew = value;
      value.forEach((element) {
        if (element['status'] == 'New') {
          tasksNew.add(element);
        } else if (element['status'] == 'done') {
          tasksDone.add(element);
        } else if (element['status'] == 'archive') {
          tasksArchive.add(element);
        }
      });
      emit(AppDatabaseGetState());
    }).catchError((e) {
      print('Error When retrieving data $e');
    });
    ;
  }

  void getTodayTasks(Database database) {
    tasksTodayPersonal = [];
    tasksTodayBusiness = [];
    emit(AppDatabaseLoadingState());
    String date = DateFormat.yMMMd().format(DateTime.now());
    database
        .rawQuery('Select * From Tasks WHERE date = ?', [date]).then((value) {
      tasksToday = value;
      value.forEach((element) {
        if (element['type'] == 'Personal') {
          tasksTodayPersonal.add(element);
        } else if (element['type'] == 'Business') {
          tasksTodayBusiness.add(element);
        }
      });
      emit(AppDatabaseGetTodayState());
    }).catchError((e) {
      print('Error When retrieving data $e');
    });
    ;
  }

  void updateDatabase({required String updateStatus, required int id}) async {
    database.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?',
        [updateStatus, id]).then((value) {
      emit(AppDatabaseUpdatedState());
      getDataFromDatabase(database);
      getTodayTasks(database);
    });
  }

  void deleteFromDatabase({required int id}) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      getTodayTasks(database);
      emit(AppDatabaseDeletedState());
    }).catchError((e) {
      print('Error when deleting row $e');
    });
  }

  String typeOfTask = 'Personal';
  void selectTaskType(String value) {
    typeOfTask = value;
    emit(AppChangeTaskTypeState());
  }

  void toAddTask() {
    emit(AppToAddTaskState());
    isTaskAdded = false;
    getTodayTasks(database);
    getDataFromDatabase(database);
  }

  void changeScreen(BuildContext context, Widget nextScene) async {
    //animation
    timeDilation = 5.0;
    await Future<void>.delayed(Duration(milliseconds: 20));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => nextScene));
    emit(AppChangeSceneState());
  }

  void openDrawer() async {
    isDrawerOpened = true;
    //animation
    timeDilation = 2.0;
    await Future<void>.delayed(Duration(milliseconds: 70));
    emit(AppDrawerOpenedState());
  }

  void closeDrawer() async {
    isDrawerOpened = false;
    //animation
    timeDilation = 10.0;
    await Future<void>.delayed(Duration(milliseconds: 70));
    emit(AppDrawerClosedState());
  }
}
