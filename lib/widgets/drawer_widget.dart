import 'package:flutter/material.dart';
import 'package:todo_app/layout/show_tasks.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
// Background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: blueColor,
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(start: 30),
          margin: const EdgeInsetsDirectional.only(end: 150),
          width: double.infinity,
          height: double.infinity,
          color: blueColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 100),
                    child: CircleAvatar(
                      child: const Image(
                        image: AssetImage('assets/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                      radius: 55,
                      backgroundColor: blueColor,
                    ),
                  ),
                  const SizedBox(width: 25),
                  circleIcon(
                      width: 42,
                      height: 42,
                      radius: 30,
                      padding: 9,
                      iconData: Icons.arrow_back_ios,
                      color: whiteColor,
                      iconColor: Colors.white70,
                      onTabFunction: () {
                        AppCubit.get(context).closeDrawer();
                      }),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    drawerElement(
                        iconData: Icons.menu,
                        title: 'New Tasks',
                        onTabFunction: () {
                          isTaskAdded = true;
                          AppCubit.get(context).changeScreen(
                              context,
                              ShowTasks(
                                tasksName: "New Tasks",
                                tasksType: TasksType.New,
                              ));
                        }),
                    const SizedBox(height: 30),
                    drawerElement(
                        iconData: Icons.done,
                        title: 'Done Tasks',
                        onTabFunction: () {
                          isTaskAdded = true;
                          AppCubit.get(context).changeScreen(
                              context,
                              ShowTasks(
                                tasksName: "Done Tasks",
                                tasksType: TasksType.done,
                              ));
                        }),
                    const SizedBox(height: 30),
                    drawerElement(
                        iconData: Icons.archive,
                        title: 'Archive Tasks',
                        onTabFunction: () {
                          isTaskAdded = true;
                          AppCubit.get(context).changeScreen(
                              context,
                              ShowTasks(
                                tasksName: "Archive Tasks",
                                tasksType: TasksType.archive,
                              ));
                        }),
                    const SizedBox(height: 30),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 120),
              Text('Developed by', style: titleStyle),
              const SizedBox(height: 8),
              Text(
                developerName,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        ),
      ],
    );
  }
}
