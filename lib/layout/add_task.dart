import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

import 'home_layout.dart';

class AddTask extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) => Form(
          key: formKey,
          child: Hero(
            tag: heroFloatingAnimation,
            child: Scaffold(
              backgroundColor: whiteColor,
              appBar: AppBar(
                backgroundColor: whiteColor,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: MediaQuery.of(context).size.width - 100),
                        child: circleIcon(
                            width: 50,
                            height: 50,
                            radius: 35,
                            padding: 0,
                            iconData: Icons.close,
                            iconColor: Colors.black,
                            color: grey2Color,
                            onTabFunction: () {
                              AppCubit.get(context)
                                  .changeScreen(context, const HomeLayout());
                              isTaskAdded = true;
                            }),
                      ),
                      const SizedBox(height: 100),
                      Column(
                        children: [
                          textField(
                              labelText: 'Enter new task..',
                              prefixIcon: Icons.title,
                              controller: titleController,
                              onTabFunction: () {},
                              validateText: 'Title mustn\'t be empty!',
                              keyboardType: TextInputType.text,
                              radius: 15),
                          const SizedBox(height: 30),
                          textField(
                              labelText: 'Today',
                              prefixIcon: Icons.calendar_today_rounded,
                              controller: dateController,
                              validateText: 'Date mustn\'t be empty!',
                              keyboardType: TextInputType.text,
                              radius: 20,
                              onTabFunction: () {
                                selectDate(context: context);
                              }),
                          const SizedBox(height: 30),
                          textField(
                              labelText: TimeOfDay.now().format(context),
                              prefixIcon: Icons.watch_later_outlined,
                              controller: timeController,
                              validateText: 'Time mustn\'t be empty!',
                              keyboardType: TextInputType.text,
                              radius: 20,
                              onTabFunction: () {
                                selectTime(context: context);
                              }),
                          const SizedBox(height: 30),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                    value: 'Business',
                                    groupValue:
                                        AppCubit.get(context).typeOfTask,
                                    onChanged: (String? value) {
                                      AppCubit.get(context)
                                          .selectTaskType(value!);
                                      print(AppCubit.get(context).typeOfTask);
                                    }),
                                const Text('Business'),
                                const SizedBox(width: 15),
                                Radio(
                                    value: 'Personal',
                                    groupValue:
                                        AppCubit.get(context).typeOfTask,
                                    onChanged: (String? value) {
                                      AppCubit.get(context)
                                          .selectTaskType(value!);
                                      print(AppCubit.get(context).typeOfTask);
                                    }),
                                const Text('Personal'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                            start: MediaQuery.of(context).size.width / 3),
                        width: 200,
                        height: 70,
                        child: Card(
                          elevation: 6,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35)),
                          child: IconButton(
                            icon: Wrap(
                                runSpacing: 15.0, // gap between lines
                                direction: Axis.vertical,
                                children: [
                                  Center(
                                      child: Text(
                                    'New Task',
                                    style: TextStyle(color: whiteColor),
                                  )),
                                  Center(
                                      child: Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    color: whiteColor,
                                  ))
                                ]),
                            onPressed: () {
                              if (dateController.text.isEmpty) {
                                dateController.text =
                                    DateFormat.yMMMd().format(DateTime.now());
                                print(dateController.text);
                              }
                              if (timeController.text.isEmpty) {
                                timeController.text =
                                    TimeOfDay.now().format(context);
                                print(timeController.text);
                              }

                              if (formKey.currentState!.validate()) {
                                AppCubit.get(context)
                                    .insertToDatabase(
                                        taskTitle: titleController.text,
                                        type: AppCubit.get(context).typeOfTask,
                                        time: timeController.text,
                                        date: dateController.text)
                                    .then((value) {
                                  AppCubit.get(context)
                                      .changeScreen(context, HomeLayout());
                                  isTaskAdded = true;
                                  titleController.text = "";
                                  timeController.text = "";
                                  dateController.text = "";
                                });
                                ;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void selectDate({required BuildContext context}) {
    int month = 0, year = 0, day = 0;
    month = DateTime.now().month == 12 ? 1 : DateTime.now().month + 1;
    year = month == 1 ? DateTime.now().year + 1 : DateTime.now().year;
    day = DateTime.now().day;
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.parse('$year-${month < 10 ? '0$month' : month}'
                '-${day < 10 ? '0$day' : day}'))
        .then((value) => {
              dateController.text = DateFormat.yMMMd().format(value!),
            });
  }

  void selectTime({required BuildContext context}) {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) => {timeController.text = value!.format(context)});
  }
}
