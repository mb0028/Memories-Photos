import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/main.dart';
import 'package:memories_photos/settings.dart';

late CameraController controller;
void initCamera(int cam, Function(int camI) oninit) {
  controller = CameraController(cameras[cam], ResolutionPreset.max);
  controller
    .initialize()
    .then((_) {
      oninit(cam);
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


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  static _CameraPageState? instance;
  double minZoom = 1.0;
  double maxZoom = 2.0;
  double zoom = 1.0;

  void onCamUpdates(int camI) async {
    minZoom = await controller.getMinZoomLevel();
    maxZoom = await controller.getMaxZoomLevel();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    instance = this;
    KeepScreenOn.turnOn();
    initCamera(0, (camI) => onCamUpdates(camI));
  }

  @override
  void dispose() {
    controller.dispose();
    KeepScreenOn.turnOff();
    instance = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Stack(
        alignment: .center,
        children: [
          Container(
            clipBehavior: .antiAlias,
            decoration: BoxDecoration(
              borderRadius: .circular(25 * Settings.rm)
            ),
            child: CameraPreview(controller)
          ),
          Padding(
            padding: MediaQuery.paddingOf(context),
            child: Column(
              mainAxisAlignment: .spaceBetween,
              children: [                
                Container(),
            
                Column(
                  spacing: 5,
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        
                      ),
                      child: Slider(
                        value: zoom,
                        min: minZoom,
                        max: maxZoom,
                        onChanged: (value) {
                          controller.setZoomLevel(value);
                          setState(() => zoom = value);
                        },
                      ),
                    ),
                    _ShutterRow(controller: controller),
                    _CameraModeRow(),
                  ],
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraModeRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 10),
      height: 35,
      child: Row(
        children: [
          OutlinedButton(
            child: Text("Normal"),
            onPressed: () => initCamera(0, (camI) => _CameraPageState.instance?.onCamUpdates(camI)),
          ),
          OutlinedButton(
            child: Text("wide"),
            onPressed: () => initCamera(0, (camI) => _CameraPageState.instance?.onCamUpdates(camI)),
          )
        ],
      )
    );
  }
}

class _ShutterRow extends StatelessWidget {
  const _ShutterRow({required this.controller});
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.camera_outlined, size: 60),
          tooltip: "Capture",
          onPressed: () async {
            var photo = await controller.takePicture();
            final t = DateTime.now();
            var time = "Photo ${t.year}-${t.month}-${t.day} ${t.hour}-${t.minute}-${t.second}.jpg";
            await photo.saveTo(Settings.appPath + Platform.pathSeparator + time);
            await File(photo.path).delete();
            showStyledToast("Saved: $time", context);
          },
        ),
        IconButton(
          icon: Icon(Icons.camera_outlined, size: 60),
          tooltip: "Capture",
          onPressed: () async {
            var photo = await controller.takePicture();
            final t = DateTime.now();
            var time = "Photo ${t.year}-${t.month}-${t.day} ${t.hour}-${t.minute}-${t.second}.jpg";
            await photo.saveTo(Settings.appPath + Platform.pathSeparator + time);
            await File(photo.path).delete();
            showStyledToast("Saved: $time", context);
          },
        ),
        IconButton(
          icon: Icon(Icons.camera_outlined, size: 60),
          tooltip: "Capture",
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
