import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/cubit/app_cubit.dart';
import 'package:todo/modules/archive_tasks.dart';
import 'package:todo/modules/done_tasks.dart';
import 'package:todo/modules/new_tasks.dart';

import '../component/constant.dart';

class Home_Layout extends StatelessWidget {
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var FormKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..CreatDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is AppInsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: ScaffoldKey,
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.blue,
                    Colors.black,
                  ],
                )),
              ),
              title: Center(
                child: Text(cubit.AppBar_Title[cubit.currentindex]),
              ),
            ),
            body:  Conditional.single(
              context: context,
              conditionBuilder: (context) => state is! AppGetDataBaseLoadingState,
              widgetBuilder: (context) => cubit.Screens[cubit.currentindex],
              fallbackBuilder: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentindex,
              onTap: (index) {
                cubit.ChangeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archive',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShowen) {
                  if (FormKey.currentState!.validate()) {
                    cubit.InsartToDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
/*
                    cubit.dataClear(title: titleController.text, time: timeController.text, date: dateController.text);
*/
                  }
                } else {
                  ScaffoldKey.currentState!
                      .showBottomSheet(
                          (context) => Container(
                                color: Colors.white,
                                padding: EdgeInsetsDirectional.all(20.0),
                                child: Form(
                                  key: FormKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: titleController,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'title must not be embty';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.title_outlined,
                                          ),
                                          label: Text('Task Title'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      TextFormField(
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                            print(value!.format(context));
                                          });
                                        },
                                        controller: timeController,
                                        //keyboardType: TextInputType.datetime,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'time must not be embty';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.watch_later_outlined,
                                          ),
                                          label: Text('Task Time'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      TextFormField(
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2023-11-01'),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                            print(DateFormat.yMMMd()
                                                .format(value));
                                          });
                                        },
                                        controller: dateController,
                                        //keyboardType: TextInputType.datetime,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'date must not be embty';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.calendar_month_outlined,
                                          ),
                                          label: Text('Task Date'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20.0)
                      .closed
                      .then((value) {
                    cubit.ChangeBottomSheet(isShow: false, icon: Icons.edit);
                  });
                  cubit.ChangeBottomSheet(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
          );
        },
      ),
    );
  }
}
