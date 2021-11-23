import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/module/archiveTask/ArchiveTasksScreen.dart';
import 'package:todo_app/module/doneTask/DoneTasksScreen.dart';
import 'package:todo_app/module/tasks/TasksScreen.dart';
import 'package:todo_app/shared/componant/companents.dart';
import 'package:todo_app/shared/componant/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget
{

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var textController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer <AppCubit , AppStates>(
        listener: (BuildContext context , AppStates state){
          if (state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder:(BuildContext context , AppStates state){
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('ToDo Tasks'),
             // elevation: 0.0,
            ),
            body: ConditionalBuilder(
              condition: state is! AppInsertDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center( child: CircularProgressIndicator(),),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if (cubit.isBottomSheetShown)
                {
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertDatabase(
                          title: textController.text,
                          time: timeController.text,
                          date: dateController.text,
                        );
                  }

                }else
                {
                  scaffoldKey.currentState!.showBottomSheet((context) {
                    return Container(
                      color: Colors.grey[300],
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                              lable: 'Task Title',
                              textController: textController,
                              prefixIcon: Icons.title,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Title must not be Empty';
                                }
                                return null;
                              },
                              textType: TextInputType.text,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                                lable: 'Task Time',
                                textController: timeController,
                                prefixIcon: Icons.watch_later_outlined,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Task Time must not be Empty';
                                  }
                                  return null;
                                },
                                textType: TextInputType.text,
                                onTap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value)
                                  {
                                    timeController.text = value!.format(context);
                                  });
                                }
                            ),

                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                                lable: 'Task Date',
                                textController: dateController,
                                prefixIcon: Icons.calendar_today,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Task Date must not be Empty';
                                  }
                                  return null;
                                },
                                textType: TextInputType.text,
                                onTap: (){
                                  showDatePicker(
                                    context: context
                                    , initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-01-01'),
                                  ).then((value)
                                  {
                                    dateController.text = DateFormat.yMMMd().format(value!);
                                  });
                                }
                            ),
                          ],
                        ),
                      ),
                    );
                  }).closed.then((value) {
                    cubit.changeBottomSheetState(
                        isShown: false,
                        icon: Icons.edit ,
                    );

                  });

                  cubit.changeBottomSheetState(
                      isShown: true,
                      icon: Icons.add,
                  );

                }
              },
              child: Icon(
                cubit.floatBottom,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              currentIndex: cubit.currentIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              selectedFontSize: 16.0,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    title: Text(
                      'Tasks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  backgroundColor: Colors.blue,
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.done_outline ,
                    ),
                  title: Text(
                    'Done',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.blue,
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive ,
                    ),
                    title: Text(
                    'Archive',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ],

              onTap: (index){
                cubit.changeIndex(index);
              },
            ),

          );
        },
      ),
    );
  }




}

