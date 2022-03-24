import 'package:flutter/material.dart';
import 'package:todo_app/reuse/item.dart';
import 'package:todo_app/shared/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/states.dart';

class Archived_tasks extends StatefulWidget {
  @override
  _Archived_tasksState createState() => _Archived_tasksState();
}

class _Archived_tasksState extends State<Archived_tasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (context, state) {
          return tasksBuilder(
            tasks: AppCubit.get(context).archivedTasks,
          );
        });
  }
}
