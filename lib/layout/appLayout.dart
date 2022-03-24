import 'package:flutter/material.dart';
import 'package:todo_app/reuse/item.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit.dart';
import 'package:todo_app/shared/states.dart';

class AppLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          return Scaffold(
            key: ScaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(AppCubit.get(context)
                  .titles[AppCubit.get(context).currentIndex]),
            ),
            body: ConditionalBuilderRec(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => AppCubit.get(context)
                  .screens[AppCubit.get(context).currentIndex],
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (AppCubit.get(context).isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  ScaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20.0),
                          color: Colors.white,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                text(
                                  controller: titleController,
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                text(
                                    controller: timeController,
                                    label: 'Task time',
                                    prefix: Icons.watch_later_outlined,
                                    type: TextInputType.datetime,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    }),
                                SizedBox(
                                  height: 15.0,
                                ),
                                text(
                                    controller: dateController,
                                    label: 'Task date',
                                    prefix: Icons.calendar_today_outlined,
                                    type: TextInputType.datetime,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'date must not be empty';
                                      }
                                    },
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2022),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      }).catchError((error) {
                                        print(error.toString());
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    AppCubit.get(context).changeBottomSheetState(
                        isshow: false, icon: Icons.edit);
                  });
                  AppCubit.get(context)
                      .changeBottomSheetState(isshow: true, icon: Icons.add);
                }
              },
              child: Icon(AppCubit.get(context).floatIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'New Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archived Tasks'),
              ],
            ),
          );
        },
      ),
    );
  }
}
