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
        fontFamily: Settings.LexendDeca,
        colorScheme: .fromSeed(
          seedColor: Settings.accent,
          dynamicSchemeVariant: .rainbow,
          brightness: MediaQuery.platformBrightnessOf(context),
        ),
        tooltipTheme: _tooltipTheme(context),
        sliderTheme: _sliderTheme(context),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent
        )
      ),
      home: MonoPHomePage(),
    );
  }

  SliderThemeData _sliderTheme(BuildContext context) {
    return SliderThemeData(
      trackHeight: 18,
      trackGap: 9,
      thumbSize: WidgetStatePropertyAll(Size(10, 50)),
      trackShape: GappedSliderTrackShape(),
      thumbShape: HandleThumbShape(),
      inactiveTrackColor: Settings.accent
    );
  }

  TooltipThemeData _tooltipTheme(BuildContext context) {
    return TooltipThemeData(
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSecondaryContainer
      ),
      decoration: BoxDecoration(
        borderRadius: .circular(50),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: .all(width: 3, color: Theme.of(context).colorScheme.outlineVariant)
      )
    );
  }
}


