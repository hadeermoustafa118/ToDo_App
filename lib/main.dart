import 'package:flutter/material.dart';
import 'package:todo_app/shared/blocObserver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/appLayout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do app',
      home: AppLayout(),
    );}}