import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/home_layout.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ShowTasks extends StatelessWidget {
  final String tasksName;
  final TasksType tasksType;
  ShowTasks({Key? key, required this.tasksName, required this.tasksType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map> tasks = [];

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, Object? state) {
          if (state is AppDatabaseGetState) {
            switch (tasksType) {
              case TasksType.New:
                tasks = AppCubit.get(context).tasksNew;
                break;
              case TasksType.done:
                tasks = AppCubit.get(context).tasksDone;
                break;
              case TasksType.archive:
                tasks = AppCubit.get(context).tasksArchive;
                break;
            }

            print("Switch $tasksType");
            print("Switch $tasks");
          }
          print('$state');
        },
        builder: (BuildContext context, state) => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .changeScreen(context, const HomeLayout());
                  },
                  icon: const Icon(Icons.arrow_back)),
              elevation: 0,
              backgroundColor: Colors.deepPurple,
              centerTitle: true,
              title: Text(
                tasksName,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: tasks.isEmpty
                ? emptyTasks()
                : listViewTasks(context: context, tasks: tasks)),
      ),
    );
  }
}
// tasksType == TasksType.New
// ? (AppCubit.get(context).tasksNew.isEmpty
// ? emptyTasks()
//     : listViewTasks(
// context: context,
// tasks: AppCubit.get(context).tasksNew))
// : tasksType == TasksType.done
// ? (AppCubit.get(context).tasksDone.isEmpty
// ? emptyTasks()
//     : listViewTasks(
// context: context,
// tasks: AppCubit.get(context).tasksDone))
// : (AppCubit.get(context).tasksArchive.isEmpty
// ? emptyTasks()
//     : listViewTasks(
// context: context,
// tasks: AppCubit.get(context).tasksArchive))),
