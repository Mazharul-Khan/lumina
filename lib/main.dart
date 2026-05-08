import 'package:flutter/material.dart';
import 'package:lumina/core/database/objectbox.dart';
import 'package:lumina/screens/home_screen.dart';

late ObjectBox objectBox;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumina',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen()
    );
  }
}
