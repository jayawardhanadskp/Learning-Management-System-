import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'LectureMaterials.dart';
import 'home.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
    
      ),
      home: MyHomePage(),
    );
  }
}