// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Widgets/blur.dart';
import 'package:memories_photos/settings.dart';
import 'package:photo_view/photo_view.dart';

class WindowsPhotoOnlyViewApp extends StatefulWidget {
  final String opendImagePath;
  const WindowsPhotoOnlyViewApp({super.key, required this.opendImagePath});

  @override
  State<WindowsPhotoOnlyViewApp> createState() => _WindowsPhotoOnlyViewAppState();
}

class _WindowsPhotoOnlyViewAppState extends State<WindowsPhotoOnlyViewApp> {
  var ctrl = PhotoViewController();
  ColorScheme? accent;
  String name = "";

  void getAccent() async {
    accent = ColorScheme.fromSeed(seedColor: await DynamicColorPlugin.getAccentColor() ?? Settings.defaultColor);
    setState(() {});
  }

  @override
  void initState() {
    getAccent();
    name = widget.opendImagePath.substring(widget.opendImagePath.lastIndexOf(Platform.pathSeparator) + 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: accent
      ),
      home: Scaffold(
        body: PhotoView(
          controller: ctrl,
          imageProvider: FileImage(File(widget.opendImagePath)),
          backgroundDecoration: BoxDecoration(
            color: MediaQuery.platformBrightnessOf(context) == .light
              ? const Color.fromARGB(255, 243, 243, 243)
              : const Color.fromARGB(255, 31, 31, 32),
          ),
        ),
        bottomNavigationBar: MediaQuery.heightOf(context) > 320 ? BlurredContainerMonoP(
          color: Colors.white.withAlpha(200),
          height: 45,
          blur: 15,
          roundneess: 0,
          padding: .symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Tooltip(
                message: widget.opendImagePath,
                child: Text(
                  name,
                  maxLines: 1,
                ),
              ),
              _ZoomSlider(),
            ],
          ),
        ) : null,
      ),
    );
  }

  Row _ZoomSlider() {
    return Row(
      children: [
        Container(
          width: 70,
          padding: .all(5),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(150),
            borderRadius: .circular(8)
          ),
          child: Text("${((ctrl.scale ?? 1) * 100).round()}%", textAlign: .center),
        ),
        Slider(
          min: 0.01,
          max: 5,
          value: ctrl.scale ?? 1,
          onChanged: (value) => setState(() => ctrl.scale = value),
        ),
        IconButton(
          icon: Icon(Icons.fit_screen_outlined),
          tooltip: "Zoom to fit",
          onPressed: () => setState(() => ctrl.scale = null),
        )
      ],
    );
  }

}