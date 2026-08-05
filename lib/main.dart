// ignore_for_file: dead_code
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories_photos/Pages/More/permissions_page.dart';
import 'package:memories_photos/Pages/More/windows_photo_only_view.dart';
import 'package:memories_photos/Pages/home_page.dart';
import 'package:memories_photos/Scripts/android_helper.dart';
import 'package:memories_photos/settings.dart';

late List<CameraDescription> cameras;

void main(List<String> args) async {
  bool testOpenWith = false;
  WidgetsFlutterBinding.ensureInitialized();

  if (!(await AndroidHelper.isExternalStorageManager())) {
    runApp(const MainApp(hasFileAccess: false));
    return;
  }
  
  await Settings.load();

  if (Platform.isWindows || testOpenWith) {
    if (args.isNotEmpty || testOpenWith) {
      runApp(WindowsPhotoOnlyViewApp(
        opendImagePath: !testOpenWith ? args.first : "E:\\_Flutter Apps\\memories_photos\\Things\\demo (1).png"
      ));
      return;
    }
  }

  if (Platform.isAndroid) cameras = await availableCameras();
  
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarIconBrightness: .dark,
    statusBarBrightness: .dark
  ));

  runApp(const MainApp(hasFileAccess: true));
}


class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.hasFileAccess});
  final bool hasFileAccess;
  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  Color seed = Settings.accent;
  static Brightness brightness = .light;
  static MainAppState? instance;
  late bool hasFileAccess;

  void changeColorSeed() async {
    var col = Settings.accent;
    if (Settings.adaptiveColors) {
      if (Platform.isAndroid)
        col = (await DynamicColorPlugin.getCorePalette())?.toColorScheme().primary ?? Settings.accent;
      else
        col = await DynamicColorPlugin.getAccentColor() ?? Settings.accent;
    }
      
    setState(() => seed = col);
  }

  void setColorSeed(Color color) {
    setState(() => seed = color);
  }

  @override
  void initState() {
    hasFileAccess = widget.hasFileAccess;
    changeColorSeed();
    super.initState();
    instance = this;
  }

  @override
  Widget build(BuildContext context) {
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
      home: hasFileAccess ? MonoPHomePage() : PermissionsPage(),
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
      preferBelow: false,
      padding: .all(15),
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontSize: 16
      ),
      decoration: BoxDecoration(
        borderRadius: .circular(40 * Settings.rm),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
          begin: .topCenter,
          end: .bottomCenter
        ),
        border: .all(width: 3, color: Theme.of(context).colorScheme.outlineVariant)
      )
    );
  }
}
