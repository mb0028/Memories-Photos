import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Structs/photo.dart';
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
  int currentCam = 0;

  void onCamUpdates(int camI) async {
    minZoom = await controller.getMinZoomLevel();
    maxZoom = await controller.getMaxZoomLevel();
    setState(() => currentCam = camI);
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
      return SizedBox();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
      ),
      body: CameraPreview(controller),

      bottomSheet: Container(
        padding: .all(5),
        height: 170 + MediaQuery.paddingOf(context).bottom,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: .circular(25)
        ),
        child: Column(
          spacing: 5,
          children: [
            _CameraModes(),
            SliderTheme(
              data: SliderThemeData(),
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
            _ShutterRow(controller: controller, currentCam: currentCam),
          ],
        ),
      ),
    );
  }
}

class _CameraModes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: .center,
        spacing: 5,
        children: [
          FilledButton.icon(
            icon: Icon(Icons.landscape_outlined),
            label: Text("Normal"),
            onPressed: () => initCamera(0, (camI) => _CameraPageState.instance?.onCamUpdates(camI)),
          ),
          cameras.length >= 2 ? FilledButton.icon(
            icon: Icon(Icons.width_wide_outlined),
            label: Text("wide"),
            onPressed: () => initCamera(2, (camI) => _CameraPageState.instance?.onCamUpdates(camI)),
          ) : SizedBox()
        ],
      )
    );
  }
}

bool _camBack = false;
class _ShutterRow extends StatelessWidget {
  const _ShutterRow({required this.controller, required this.currentCam});
  final CameraController controller;
  final int currentCam; 

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.cameraswitch_outlined, size: 40),
          tooltip: "Change camera",
          onPressed: () {
            initCamera(
              currentCam + (_camBack ? -1 : 1),
              (camI) => _CameraPageState.instance?.onCamUpdates(camI)
            );
            _camBack = !_camBack;
          },
        ),
        IconButton(
          icon: Icon(Icons.camera_outlined, size: 60),
          tooltip: "Capture",
          onPressed: () async {
            var photo = await controller.takePicture();
            final t = DateTime.now();
            var time = "Photo ${t.year}-${t.month}-${t.day} ${t.hour}-${t.minute}-${t.second}.jpg";
            var finalPath = Settings.appPath + Platform.pathSeparator + time;
            await photo.saveTo(finalPath);
            await File(photo.path).delete();
            
            showStyledToast("Saved: $time", context);
            if (Settings.editCommentAfterCamPic)
              (await Photo.fromPath(finalPath)).showEditCommentPopup(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.photo_camera_front, size: 40),
          tooltip: "Record",
          onPressed: () => showStyledToast("Coming Soon!", context),
        ),
      ],
    );
  }
}
