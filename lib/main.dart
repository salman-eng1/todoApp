import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/todo_app/todo_layout.dart';
import 'package:todo_app/shared/styles/themes.dart';
import 'layout/todo_app/cubit/cubit.dart';
import 'layout/todo_app/cubit/states.dart';

void main()  {

      runApp(MyApp());

  }

class MyApp extends StatelessWidget {
  MyApp();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            themeMode: ThemeMode.light,
            home: HomeLayout(),
          );
        },
      ),
    );
  }
}
