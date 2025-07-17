import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const TahoStoryApp());
}

class TahoStoryApp extends StatelessWidget {
  const TahoStoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taho Story',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'HarmonyOS Sans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8C42),
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
