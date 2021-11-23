import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/componant/companents.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class TasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer <AppCubit , AppStates>(
        listener: (context , state){},
        builder: (context , state){
          List tasks = AppCubit.get(context).tasks;
          return ConditionalBuilder(
            condition: tasks.length > 0,
            builder: (context) => ListView.separated(
              itemBuilder: (context , index){
                return tasksListItem(tasks[index] , context);
              },
              separatorBuilder: (context , index)
              {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: tasks.length,
            ),
            fallback: (context) => taskScreenEmpty(),
          );
        },
    );
  }
}
