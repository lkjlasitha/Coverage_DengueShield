import 'package:flutter/material.dart';

class InformScreen extends StatefulWidget {
  const InformScreen({super.key});

  @override
  State<InformScreen> createState() => _InformScreenState();
}

class _InformScreenState extends State<InformScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        'this is inform page'
      ),
    );
  }
}