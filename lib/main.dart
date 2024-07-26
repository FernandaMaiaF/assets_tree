import 'package:assets_tree/screens/assets_screen.dart';
import 'package:assets_tree/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assets Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF17192D)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          foregroundColor: Color(0xFFFFFFFF),
          backgroundColor: Color(0xFF17192D),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        HomeScreen.routName: (context) => const HomeScreen(),
        AssetScreen.routName: (context) => const AssetScreen(),
      },
    );
  }
}
