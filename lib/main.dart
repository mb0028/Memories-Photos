import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/home_page.dart';
import 'package:memories_photos/settings.dart';

late FragmentProgram colorfulBackgroundProgram;

void main() async {
  await Settings.load();
  colorfulBackgroundProgram = await FragmentProgram.fromAsset("Assets/Shaders/bg.frag");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "LexendDeca",
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 164, 255, 196),
          dynamicSchemeVariant: .rainbow,
          brightness: MediaQuery.platformBrightnessOf(context),
        ),
      ),
      home: MonoPHomePage(),
    );
  }
}


