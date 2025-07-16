import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(TahoStoryApp());
}

class TahoStoryApp extends StatelessWidget {
  const TahoStoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taho Story',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomeScreen(),
    );
  }
}
