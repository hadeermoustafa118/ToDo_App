import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../reuse/item.dart';
import '../shared/cubit.dart';
import '../shared/states.dart';

class Archived_tasks extends StatefulWidget {
  @override
  _Archived_tasksState createState() => _Archived_tasksState();
}

class _Archived_tasksState extends State<Archived_tasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: ( context,  state) {},
        builder: (context, state) {
          return tasksBuilder(
            tasks: AppCubit.get(context).archivedTasks,
          );
        });
  }
}
