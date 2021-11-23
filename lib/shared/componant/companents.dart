import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultFormField({
  required final String lable,
  required final textController,
  required final IconData prefixIcon,
  required final String? Function(String?)? validator,
  final TextInputType textType = TextInputType.text,
  final Function()? onTap,
}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: lable,
      labelStyle: TextStyle(
        fontSize: 18.0,
        color: Colors.blue,
      ),
      border: OutlineInputBorder(),
      prefixIcon: Icon(prefixIcon),
    ),
    controller: textController,
    keyboardType: textType,
    validator: validator,
    onTap: onTap,
  );
}

Widget tasksListItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.white,
              child: Text(
                '${model['time']}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: model['id']);
              },
              icon: Icon(
                Icons.check_box_outlined,
                color: Colors.white,
                size: 25.0,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archive', id: model['id']);
              },
              icon: Icon(
                Icons.archive,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.blue,
        ),
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteDatabase(id: model['id']);
    },
  );
}

Widget taskScreenEmpty() => Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Task added yet , Add task',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
