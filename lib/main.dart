// Import directives
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:uitmscheduler/models/selected.dart';

// Screens
import 'package:uitmscheduler/views/home.dart';
import 'package:uitmscheduler/views/campus_selection.dart';
import 'package:uitmscheduler/views/faculty_selection.dart';
import 'package:uitmscheduler/views/course_selection.dart';
import 'package:uitmscheduler/views/group_selection.dart';
import 'package:uitmscheduler/views/result.dart';
import 'package:uitmscheduler/views/experimental_home.dart';

Future main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Selected>(SelectedAdapter());
  await Hive.openBox<Selected>("selectedCourse");
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // main screens
        '/': (context) => Home(),
        '/campus_selection': (context) => CampusSelection(),
        '/faculty_selection': (context) => FacultySelection(),
        '/course_selection': (context) => CourseSelection(),
        '/group_selection': (context) => GroupSelection(),
        '/result': (context) => Result(),

        // experimental screens
        '/experimental_home': (context) => ExperimentalHome()
      },
    );
  }
}
