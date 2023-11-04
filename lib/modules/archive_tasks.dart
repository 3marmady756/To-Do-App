import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/component.dart';
import '../cubit/app_cubit.dart';

class ArchiveTasks_Screen extends StatelessWidget {
  const ArchiveTasks_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppState>(
      listener: (context , state){},
      builder: (BuildContext context, AppState state) {
        var tasks = AppCubit.get(context).archiveTasks;
        return TaskBuilder(tasks: tasks, context: context);
      },

    );
  }
}
