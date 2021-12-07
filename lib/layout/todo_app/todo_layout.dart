// ignore: import_of_legacy_library_into_null_safe
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/components/components.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeLayout extends StatelessWidget
{
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController =TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if (state is AppInsertDatabaseState){
               Navigator.pop(context);
          }
          //listener
        },
        builder: (context,state) {
          AppCubit cubit = AppCubit.get(context);
            return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.body[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!
                      .validate()) { //if the fields not empty
                   cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    ).then((value) {
                      // getDataFromDatabase(database).then((value) {
                      //   Navigator.pop(context);
                      //   // setState(() {
                      //   //   isBottomSheetShown = false;
                      //   //   fabIcon = Icons.edit;
                      //   //   tasks = value;
                      //   // });
                      // });
                    });
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                  isPassword: false,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                  },
                                  controller: titleController,
                                  type: TextInputType.text,
                                  label: "Task title",
                                  prefix: Icons.title

                              ),
                              SizedBox(height: 10.0,),
                              defaultFormField(
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                },
                                controller: timeController,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showTimePicker(context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value!.format(context);
                                  });
                                },
                                label: "Task time",
                                prefix: Icons.watch_later_outlined,
                                isPassword: false,
                              ),
                              SizedBox(height: 10.0,),
                              defaultFormField(
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                },
                                controller: dateController,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("2022-12-03")
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                label: "Task Date",
                                prefix: Icons.calendar_today_outlined,
                                isPassword: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 20.0
                  ).closed.then((value) {

                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit
                    );
                  });

                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add
                  );
                }
              },
              child: Icon(
                  cubit.fabIcon
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                //   setState(() {
                AppCubit.get(context).changeIndex(index);
                //   });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
              ],
            ),
          );
        }
      ),
    );
  }

}

