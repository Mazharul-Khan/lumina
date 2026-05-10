import 'package:flutter/material.dart';
import 'package:lumina/core/database/objectbox.dart';
import 'package:lumina/core/theme/app_theme.dart';
import 'package:lumina/screens/home_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

late ObjectBox objectBox;

void main() async {
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        quill.FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      title: 'Lumina',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: HomeScreen(),
    );
  }
}
