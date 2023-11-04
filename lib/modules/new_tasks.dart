import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/app_cubit.dart';

import '../component/component.dart';
import '../component/constant.dart';

class NewTasks_Screen extends StatelessWidget {
  const NewTasks_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppState>(
      listener: (context , state){},
      builder: (BuildContext context, AppState state) {
        var tasks = AppCubit.get(context).newTasks;
        return TaskBuilder(tasks: tasks, context: context);
      },

    );
  }
}
