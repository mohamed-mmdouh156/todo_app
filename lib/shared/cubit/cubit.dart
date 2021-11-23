import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/module/archiveTask/ArchiveTasksScreen.dart';
import 'package:todo_app/module/doneTask/DoneTasksScreen.dart';
import 'package:todo_app/module/tasks/TasksScreen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0 ;
  List <Map> tasks = [];
  List <Map> doneTasks = [];
  List <Map> archiveTasks = [];

  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];

  late Database database;

  bool isBottomSheetShown = false;
  IconData floatBottom = Icons.edit;



  void changeIndex (int index)
  {
    currentIndex = index ;
    emit(AppChangeNavBarState());
  }

  void createDatabase ()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database , version){
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT )').then((value)
        {
          print('database created successful');
        }).catchError((error)
        {
          print('error when creating database ${error.toString()}');
        });
      },

      onOpen: (database){
        print('database opened');
        getDataFromDatabase(database);
      },
    ).then((value)
    {
      database = value ;
      emit(AppCreateDatabaseState());
    }
    );
  }



  insertDatabase ({
    required String title ,
    required String time ,
    required String date ,
  }) async
  {
     await database.transaction((txn) {

      txn.rawInsert(
          'INSERT INTO tasks(title , date , time , status) VALUES("$title" , "$date" , "$time" , "new")'
      ).then((value)
      {
        print('$value : insert successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error){
        print('error when insert row ${error.toString()}');
      });

      return null;
    }
    );
  }


  void getDataFromDatabase (database) async {
    tasks = [];
    doneTasks = [];
    archiveTasks = [];

     emit(AppInsertDatabaseLoadingState());

     database.rawQuery('SELECT * FROM tasks').then((value)
     {
       // tasks = value ;
       value.forEach((element)
       {
         if(element['status'] == 'new')
           {
             tasks.add(element);
           }
         else if (element['status'] == 'done')
           {
             doneTasks.add(element);
           }
         else{
           archiveTasks.add(element);
         }

       });

       emit(AppGetDatabaseState());
     }
     );

  }

  void changeBottomSheetState ({
    required bool isShown ,
    required IconData icon ,
})
{
  isBottomSheetShown = isShown ;
  floatBottom = icon ;

  emit(AppChangeBottomSheetState());
}

void updateDatabase ({
  required String status ,
  required int id ,
})
{
  database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?' ,
      ['$status' , id] ).then((value)
  {
    emit(AppUpdateDatabaseState());
    getDataFromDatabase(database);
  }
  );
}

  void deleteDatabase ({
    required int id ,
  })
  {
    database.rawDelete(
        'DELETE FROM tasks  WHERE id = ?' , [id] ).then((value)
    {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database);
    }
    );
  }




}