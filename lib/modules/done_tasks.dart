import 'package:flutter/material.dart';
import 'package:todo_app/reuse/item.dart';
import 'package:todo_app/shared/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/states.dart';

class Done_tasks extends StatefulWidget {
  const Done_tasks({Key? key}) : super(key: key);

  @override
  _Done_tasksState createState() => _Done_tasksState();
}

class _Done_tasksState extends State<Done_tasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (context, state) {
          return tasksBuilder(
            tasks: AppCubit.get(context).doneTasks,
          );
        });
  }
}
