import 'dart:ui';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/home_page.dart';
import 'package:memories_photos/settings.dart';

late FragmentProgram colorfulBackgroundProgram;

void main() async {
  await Settings.load();
  colorfulBackgroundProgram = await FragmentProgram.fromAsset("Assets/Shaders/bg.frag");
  if (Settings.adaptiveColors) {
    WidgetsFlutterBinding.ensureInitialized();
  }
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  Color seed = Settings.accent;
  static Brightness brightness = .light;
  static MainAppState? instance;

  void chnageColorSeed() async {
    var col = Settings.accent;
    if (Settings.adaptiveColors)
      col = await DynamicColorPlugin.getAccentColor() ?? Settings.accent;
    setState(() => seed = col);
  }

  void setColorSeed(Color color) {
    setState(() => seed = color);
  }

  @override
  void initState() {
    chnageColorSeed();
    super.initState();
    instance = this;
  }

  @override
  Widget build(BuildContext context) {
    brightness = MediaQuery.platformBrightnessOf(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: Settings.LexendDeca,
        colorScheme: .fromSeed(
          seedColor: seed,
          dynamicSchemeVariant: .rainbow,
          brightness: brightness
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
      inactiveTrackColor: seed.withAlpha(100)
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


