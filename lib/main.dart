import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/home_page.dart';
import 'package:system_theme/system_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemTheme.fallbackColor = Colors.greenAccent;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: SystemTheme.accentColor.accent,
          dynamicSchemeVariant: .rainbow,
          brightness: MediaQuery.platformBrightnessOf(context)
        ),
      ),
      home: MonoPHomePage(),
    );
  }
}


