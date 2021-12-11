import 'package:flutter/material.dart';

Color whiteColor = const Color(0xFFF4F6Fd);
Color greyColor = const Color(0xFF9d9ab4);
Color grey2Color = const Color(0xFFADBAEB);
Color blueColor = const Color(0xFF2643C4);

Color personalColor = Colors.blue;
Color businessColor = Colors.pink;

String username = 'Suger';
String developerName = 'Khaled Abdelrazeq';
String heroFloatingAnimation = 'heroAddTaskAnim';

var cardShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));
var titleStyle = TextStyle(color: greyColor, fontSize: 15);

double maxSliderValue = 80;
bool isTaskAdded = false;

// Drawer constant
bool isDrawerOpened = false;

enum TasksType { New, done, archive }
