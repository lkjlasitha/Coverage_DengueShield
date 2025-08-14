import 'package:flutter/material.dart';
import 'widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dengue_Shield_APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // Set the default font family here
      ),
      home: CustomBottomNav()
    );
  }
}