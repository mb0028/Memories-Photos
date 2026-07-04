import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/main.dart';
import 'package:memories_photos/settings.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  double minZoom = 1.0;
  double maxZoom = 2.0;
  double zoom = 1.0;
  var padding = EdgeInsets.all(0);

  void initCameraZoom() async {
    minZoom = await controller.getMinZoomLevel();
    maxZoom = await controller.getMaxZoomLevel();
    setState(() {});
  }

  void initCamera(int cam) {
    controller = CameraController(cameras[cam], ResolutionPreset.max);
    controller
      .initialize()
      .then((_) {
        if (!mounted)
          return;
        initCameraZoom();
        setState(() {});
      })
      .catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });
  }

  @override
  void initState() {
    super.initState();
    initCamera(0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    padding = MediaQuery.paddingOf(context);
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          SizedBox(height: padding.top),
          Flexible(child: CameraPreview(controller)),
          
          Container(
            padding: .symmetric(horizontal: 10),
            height: 35,
            child: ListView.builder(
              itemCount: cameras.length,
              scrollDirection: .horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => OutlinedButton(
                onPressed: () => initCamera(index), 
                child: Text(
                  "${switch (cameras[index].lensDirection) {
                    .front => "Front",
                    .back => "Back",
                    _ => "???"
                  }} ${switch (cameras[index].lensType) {
                    .telephoto => "Default",
                    .wide => "Wild",
                    .ultraWide => "Ultrawild",
                    _ => "???"
                  }}"
                )
              ),
            ),
          ),

          Slider(
            value: zoom,
            min: minZoom,
            max: maxZoom,
            onChanged: (value) async {
              await controller.setZoomLevel(value);
              setState(() => zoom = value);
            },
          ),

          ShutterRow(controller: controller),
          SizedBox(height: padding.bottom)
        ],
      ),
    );
  }
}

class ShutterRow extends StatelessWidget {
  const ShutterRow({
    super.key,
    required this.controller,
  });
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceAround,
      children: [
        IconButton.filled(
          icon: Icon(Icons.camera, size: 60),
          onPressed: () async {
            var photo = await controller.takePicture();
            final t = DateTime.now();
            var time = "Photo ${t.year}-${t.month}-${t.day} ${t.hour}-${t.minute}-${t.second}.jpg";
            await photo.saveTo(Settings.appPath + Platform.pathSeparator + time);
            await File(photo.path).delete();
            showStyledToast("Saved: $time", context);
          },
        ),
      ],
    );
  }
}
