import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import '../modules/archive_tasks.dart';
import '../modules/done_tasks.dart';
import '../modules/new_tasks.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentindex = 0;
  List<Widget> Screens = [
    NewTasks_Screen(),
    DoneTasks_Screen(),
    ArchiveTasks_Screen(),
  ];
  List<String> AppBar_Title = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  void ChangeIndex(index) {
    currentindex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void CreatDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) async {
      print('DataBase created');
      await database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
          .then((value) {
        print('Table created');
      }).catchError((error) {
        print('error when creat table is ${error.toString()}');
      });
    }, onOpen: (database) {
      getFromDatabase(database);
      print('database opend');
    }).then((value) {
      database = value ;
      emit(AppCreatDataBaseState());
    });
  }

   InsartToDataBase({
    required title,
    required time,
    required date,
  }) async {
     await database!.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks (title , date , time , status ) VALUES ("$title" , "$date" , "$time" , "new")')
          .then((value) {
        emit(AppInsertDataBaseState());

        print('$value Insart Table Successfully');
        getFromDatabase(database);
      }).catchError((error) {
        print('error when insert table is ${error.toString()}');
      });
    });
  }

  void dataClear({
    required title,
    required time,
    required date,
  }){
    title.clear();
    time.clear();
    date.clear();
    emit(AppDeletDataState());
  }

  void getFromDatabase(database)  {

    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDataBaseLoadingState());
    database.rawQuery(' SELECT * FROM tasks ').then((value) {
      value.forEach((element) {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
        doneTasks.add(element);
        else
          archiveTasks.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async
  {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value)
    {
      getFromDatabase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void DeletData({
    required int id,
  }) async
  {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      getFromDatabase(database);
      emit(AppDeletDataBaseState());
    });
  }

  bool isBottomSheetShowen = false;
  IconData fabIcon = Icons.edit;

  void ChangeBottomSheet({
    required bool isShow ,
    required IconData icon ,
}){
    isBottomSheetShowen = isShow ;
    fabIcon = icon ;
    emit(AppChangeBottomSheetBarState());
  }
}
