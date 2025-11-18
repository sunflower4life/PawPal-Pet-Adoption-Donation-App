import 'package:flutter/material.dart';
import 'package:pawpal/views/splashscreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.cyan),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 72, 38, 44),
          foregroundColor: Color.fromARGB(255, 255, 244, 215),
        )
      ),
      home: Splashscreen(),
    );
  }
}