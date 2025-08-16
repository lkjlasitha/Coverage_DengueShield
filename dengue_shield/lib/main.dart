import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/apointment_screen/apointment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MosquitoTestFlowScreen()
    );
  }
}