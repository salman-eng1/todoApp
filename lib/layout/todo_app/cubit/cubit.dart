import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/todo_app/cubit/states.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>{


  AppCubit() : super(AppInitialStates());

  static AppCubit get(context)=>BlocProvider.of(context);

  List<Map> tasks=[];
  bool isBottomSheetShown = false;
  IconData fabIcon=Icons.edit;

  int currentIndex = 0;
  List<Widget> body = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> title = [
    "Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
  late Database database;

  void changeIndex(int Index)
  {
    currentIndex=Index;
    emit(AppChangeBottomNavBarState(currentIndex));
  }


  void createDatabase()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,version)
      {
        print('database created');
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value){
          print("table created");
        }).catchError((error){
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (database){
        getDataFromDatabase(database).then((value){
          tasks=value;
          emit(AppGetDatabaseState());
           print(tasks);
        });
        print("database opened");
      },
    ).then((value){
      database=value;
      emit(AppCreateDatabaseState());
    });
  }


  insertToDatabase({
    required String title,
    required String time,
    required String date,}) async
  {
   await  database.transaction((txn) async
    {
      txn.rawInsert('INSERT INTO tasks(title,time,date,status) VALUES("$title","$time","$date","new")')
          .then((value){
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database).then((value){
          tasks=value;
          emit(AppGetDatabaseState());
          print(tasks);
        });

      }).catchError((error){
        print("Error when inserting new record ${error.toString()}");
      });
      return;
    });
  }


  Future<List<Map>> getDataFromDatabase(database) async {
    emit(AppGetDatabaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks');
  }



  void updateData({
  required String status,
  required int id,
})
  async {
     database.rawUpdate(
        'UPDATE tasks SET status=? WHERE id=?',
        ['$status',id]
     ).then((value){
       emit(AppUpdateDatabaseState());
     });

  }


  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown=isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }



  var x= deleteDatabase("todo.db");

}
