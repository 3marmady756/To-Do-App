import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../component/component.dart';
import '../cubit/app_cubit.dart';

class DoneTasks_Screen extends StatelessWidget {
  const DoneTasks_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (BuildContext context, AppState state) {
        var tasks = AppCubit.get(context).doneTasks;
        return TaskBuilder(tasks: tasks, context: context);
      },
    );
  }
}

