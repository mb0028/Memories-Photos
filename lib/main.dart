import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/home_page.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await PhotoIndexer.startCa();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 164, 255, 196),
          dynamicSchemeVariant: .tonalSpot,
          brightness: MediaQuery.platformBrightnessOf(context)
        ),
      ),
      home: MonoPHomePage(),
    );
  }
}


