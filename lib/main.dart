import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/task_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: TaskHome(
        title: "Task Manager",
      ),
    );
  }
}
