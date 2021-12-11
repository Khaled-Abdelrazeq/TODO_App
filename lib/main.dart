import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/bloc_observer.dart';

import 'layout/home_layout.dart';

void main() {
  runApp(const MyApp());
  BlocOverrides.runZoned(
    () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(
            secondary: Colors.blue, onSecondary: Colors.white),
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          }, //FadeUpwardsPageTransitionsBuilder   -  ZoomPageTransitionsBuilder  -
          // OpenUpwardsPageTransitionsBuilder  -  CupertinoPageTransitionsBuilder
        ),
      ),
      home: const HomeLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
