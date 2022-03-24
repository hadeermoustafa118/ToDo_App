import 'package:flutter/material.dart';
import 'package:todo_app/reuse/item.dart';
import 'package:todo_app/shared/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/states.dart';
import 'package:conditional_builder_rec/conditional_builder_rec.dart';

class New_tasks extends StatefulWidget {
  const New_tasks({Key? key}) : super(key: key);

  @override
  _New_tasksState createState() => _New_tasksState();
}

class _New_tasksState extends State<New_tasks> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
    listener: ( BuildContext context, AppStates state){},
    builder: (context, state){
      return tasksBuilder(
        tasks: AppCubit.get(context).newTasks,
      );

    }
    );}
}
