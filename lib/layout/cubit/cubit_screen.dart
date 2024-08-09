import 'package:bloc/bloc.dart';
import 'package:finishflutter_app/layout/cubit/states.dart';
import 'package:finishflutter_app/modules/archived_task/archives_screen.dart';
import 'package:finishflutter_app/modules/done_tasks/done_screen.dart';
import 'package:finishflutter_app/modules/new_tasks/new_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class CubitApp extends Cubit<AppStates> {
  CubitApp() : super(InitialState());
  List<Widget> screen = [NewScreen(), DoneScreen(), ArchivedScreen()];
  List<String> appBar = ["New Task", "Done Task", "Archived Task"];
  int currenIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Map> tasks = [];
  late Database database;
  IconData icon = Icons.edit;
  bool isFloatingActionBootom = false;

  static CubitApp getObject(context) {
    return BlocProvider.of(context);
  }

  void changeCurrentIndex(index) {
    currenIndex = index;
    emit(ChangeBottomNavBar());
  }

  void changeFloatingButton(bool isShown, icon) {
    this.icon = icon;
    isFloatingActionBootom = isShown;
    emit(ChangeFloatingButton());
  }

  void createDataBase(context) {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (db, version) {
        print("database created");
        db
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
            .then((value) {
          emit(CreateDataBase());
          print("table created");
        }).catchError((onError) {
          print(onError.toString());
        });
      },
      onOpen: (db) {
        getDataBase(db, context);
        print("databaseopend");
      },
    ).then((value) {
      database = value;
    });
  }

  void insertDataBase(title, time, date, context) {
    database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Tasks(title, date, time,status) VALUES("$title", "$date", "$time","new")')
          .then((value) {
        getDataBase(database, context);
        print("$value inserted to database");
      });
    }).then((value) {
      Navigator.pop(context);
      emit(InsertDataBase());
    });
  }

  void getDataBase(database, context) async {
    tasks = await database.rawQuery('SELECT * FROM Tasks');
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(GetDataBase());
    tasks.forEach((element) {
      if (element["status"] == "new")
        newTasks.add(element);
      else if (element["status"] == "done")
        doneTasks.add(element);
      else
        archivedTasks.add(element);
    });
    newTasks.forEach((element) {
      print(element);
    });
  }

  void updateDataBase(states, id, context) {
    database.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?',
        ['$states', '$id']).then((value) {
      emit(UpdateDataBase());
      getDataBase(database, context);
    });
  }

  void deleteRecord(id, context) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      emit(DeleteRecord());
      getDataBase(database, context);
    });
  }
}
