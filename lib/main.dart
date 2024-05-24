import 'package:flutter/material.dart';
import 'package:promissorynotemanager/screens/aunthentication_fail.dart';
import 'package:promissorynotemanager/screens/home_page.dart';
import 'package:promissorynotemanager/screens/login_page.dart';
import 'package:promissorynotemanager/screens/nothing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogInPage(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("hello flutter again,"),
      ),
    );
  }
}
