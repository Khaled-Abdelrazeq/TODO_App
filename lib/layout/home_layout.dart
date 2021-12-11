import 'package:drawerbehavior/drawer_scaffold.dart';
import 'package:drawerbehavior/menu_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/add_task.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/widgets/drawer_widget.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {
          if (state is AppDatabaseCreatedState) {
            if (isTaskAdded) {
              AppCubit.get(context).toAddTask();
            }
          }
        },
        builder: (BuildContext context, Object? state) => Stack(
          children: [
            isDrawerOpened
                ? const Scaffold(
                    body: DrawerWidget(),
                  )
                : Container(),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: isDrawerOpened ? 220 : 0,
                  top: isDrawerOpened ? 70 : 0,
                  bottom: isDrawerOpened ? 70 : 0,
                  end: 0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(isDrawerOpened ? 10 : 0)),
                margin: const EdgeInsetsDirectional.only(start: 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 4.0, top: 4, bottom: 4),
                  child: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Color(0xFFADBAEB),
                        ),
                        onPressed: () {
                          AppCubit.get(context).openDrawer();
                        },
                      ),
                      backgroundColor: whiteColor,
                      elevation: 0,
                      // actions: [
                      //   isDrawerOpened
                      //       ? Container()
                      //       : Row(
                      //           children: [
                      //             IconButton(
                      //                 onPressed: () {},
                      //                 icon: const Icon(
                      //                   Icons.search,
                      //                   color: Color(0xFFADBAEB),
                      //                 )),
                      //             IconButton(
                      //                 onPressed: () {},
                      //                 icon: const Icon(
                      //                   Icons.notification_important,
                      //                   color: Color(0xFFADBAEB),
                      //                 )),
                      //           ],
                      //         )
                      // ],
                    ),
                    body: Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 30, end: isDrawerOpened ? 0 : 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              'What\'s up, $username!',
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 10.0),
                                child: Text(
                                  'CATEGORIES',
                                  style: titleStyle,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    taskCategory(
                                        context: context,
                                        tasks: AppCubit.get(context)
                                            .tasksTodayBusiness,
                                        sliderColor: Colors.pinkAccent,
                                        title: 'Business'),
                                    taskCategory(
                                        tasks: AppCubit.get(context)
                                            .tasksTodayPersonal,
                                        context: context,
                                        sliderColor: Colors.blue,
                                        title: 'Personal'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text('TODAY\'S TASKS', style: titleStyle),
                          const SizedBox(height: 5),
                          Expanded(
                              child: AppCubit.get(context).tasksToday.isEmpty
                                  ? emptyTasks()
                                  : listViewTasks(
                                      context: context,
                                      tasks: AppCubit.get(context).tasksToday)),
                        ],
                      ),
                    ),
                    floatingActionButton: isDrawerOpened
                        ? Container()
                        : FloatingActionButton(
                            heroTag: heroFloatingAnimation,
                            onPressed: () {
                              AppCubit.get(context)
                                  .changeScreen(context, AddTask());
                            },
                            child: const Icon(Icons.add),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
