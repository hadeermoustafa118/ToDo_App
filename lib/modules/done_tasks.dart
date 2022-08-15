import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../reuse/item.dart';
import '../shared/cubit.dart';
import '../shared/states.dart';

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
