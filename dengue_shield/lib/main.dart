import 'package:dengue_shield/screens/auth/login_screen.dart';
import 'package:dengue_shield/screens/onboard/onboard_screen.dart';
import 'package:dengue_shield/screens/onboard/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dengue_Shield_APP',
      theme: ThemeData(
        fontFamily: 'Poppins', // Set the default font family here
      ),
      home: LoginScreen()
    );
  }
}