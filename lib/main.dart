import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/demarrage.dart';
import 'package:todo/provider/user_provider.dart';
import 'package:todo/view/loginscreen.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/view/task_list.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion de tâches',
      initialRoute: '/',
      routes: {
        '/': (context) => DemarragePage(),
        '/login': (context) => LoginScreen(),
        '/tasks': (context) => const TaskListView(),
      },
    );
  }
}
