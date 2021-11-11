// Import directives
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// .env file for loading environment variables
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Screens
import 'package:uitmscheduler/screens/home.dart';
import 'package:uitmscheduler/screens/selection.dart';
import 'package:uitmscheduler/screens/result.dart';

Future main() async {
  // Loading env file for accessing secured environment variables
  await dotenv.load(fileName: "local.env");
  
  runApp(
    ProviderScope(
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
        '/': (context) => Home(),
        '/selection': (context) => Selection(),
        '/result': (context) => Result(),
      },
    );
  }
}
