// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:memories_photos/Pages/settings_page.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Scripts/ExifInterface/exif_interface.dart';
import 'package:memories_photos/Scripts/ExifInterface/tags.dart';
import 'package:memories_photos/Scripts/android_helper.dart';
import 'package:memories_photos/Scripts/camera_helper.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/main.dart';
import 'package:memories_photos/settings.dart';

late CameraController _controller;
int _currentCam = 0;
ExposureMode _currentExpoMode = .auto;
FocusMode _currentFocusMode = .auto;
double _previewScale = 1;
void _initCamera(int cam, Function(int camI) oninit) {
  _controller = CameraController(cameras[cam], ResolutionPreset.max);
  _controller
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
  _currentCam = cam;
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
  double minExpoOffset = 1.0;
  double maxExpoOffset = 2.0;
  double zoom = 1.0;
  double expoOffset = 0.0;

  void onCamUpdates(int camI) async {
    minZoom = await _controller.getMinZoomLevel();
    maxZoom = await _controller.getMaxZoomLevel();
    minExpoOffset = await _controller.getMinExposureOffset();
    maxExpoOffset = await _controller.getMaxExposureOffset();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    instance = this;
    KeepScreenOn.turnOn();
    _initCamera(0, (camI) => onCamUpdates(camI));
  }

  @override
  void dispose() {
    _controller.dispose();
    KeepScreenOn.turnOff();
    instance = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return SizedBox();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      resizeToAvoidBottomInset: false,
      appBar: _Appbar(),
      
      body: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          AnimatedScale(
            scale: _previewScale,
            duration: Duration(milliseconds: 1000),
            curve: ElasticOutCurve(3),
            child: CameraPreview(_controller)
          ),
          Container(
            padding: .all(5),
            height: 195 + MediaQuery.paddingOf(context).bottom,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: .circular(25)
            ),
            child: Column(
              spacing: 5,
              children: [
                _CamerasRow(),
                _CameraModesRow(),
                _ZoomSlider(context),
                // _ExpoSlider(context),
                _ShutterRow(controller: _controller),
              ],
            ),
          ),
        ],
      ),

    );
  }

  AppBar _Appbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 45,
      leading: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage(onlyShowCamera: true))),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.high_quality_outlined),
          onPressed: () => _controller.setZoomLevel(minZoom),
        ),
        IconButton(
          icon: Icon(Icons.flash_off_rounded),
          onPressed: () => _controller.setZoomLevel(minZoom),
        ),
        IconButton(
          icon: Icon(Icons.comment_bank_outlined),
          onPressed: () => _controller.setZoomLevel(minZoom),
        ),
        IconButton(
          icon: Icon(Icons.aspect_ratio_outlined),
          onPressed: () => _controller.setZoomLevel(minZoom),
        ),
      ],
    );
  }

  ListTile _ZoomSlider(BuildContext context) {
    return ListTile(
      minTileHeight: 30,
      contentPadding: .symmetric(horizontal: 5),
      leading: IconButton(
        icon: Icon(Icons.zoom_out),
        onPressed: () {
          _controller.setZoomLevel(minZoom);
          setState(() => zoom = minZoom);
        },
      ),
      trailing: IconButton(
        icon: Icon(Icons.zoom_in),
        onPressed: () {
          _controller.setZoomLevel(maxZoom);
          setState(() => zoom = maxZoom);
        },
      ),
      title: SliderTheme(
        data: cameraSliderTheme(context),
        child: Slider(
          value: zoom,
          min: minZoom,
          max: maxZoom,
          label: "${zoom.toString().length > 4 ? zoom.toString().substring(0, 4) : zoom}",
          onChanged: (value) {
            _controller.setZoomLevel(value);
            setState(() => zoom = value);
          },
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _ExpoSlider(BuildContext context) {
    return SliderTheme(
      data: cameraSliderTheme(context),
      child: Slider(
        padding: .symmetric(horizontal: 15),
        value: expoOffset,
        min: minExpoOffset,
        max: maxExpoOffset,
        label: "${expoOffset.toString().length > 4 ? expoOffset.toString().substring(0, 4) : expoOffset}",
        onChanged: (value) {
          try {
            _controller.setExposureOffset(value);
            setState(() => expoOffset = value);
          } on Exception {}
        },
      ),
    );
  }
}

class _CamerasRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: cameras.length,
        itemBuilder: (context, index) => Padding(
          padding: .symmetric(horizontal: 5),
          child: FilledButton.icon(
            style: ButtonStyle(
              backgroundColor: .all(index == _currentCam ? Theme.of(context).colorScheme.tertiary : null)
            ),
            icon: Icon(switch (cameras[index].lensDirection) {
              .front => Icons.camera_front_rounded,
              .back => Icons.photo_camera_back_outlined,
              .external => Icons.linked_camera_outlined,
            }),
            label: Text(cameras[index].name),
            onPressed: () => _initCamera(index, (camI) => _CameraPageState.instance?.onCamUpdates(camI)),
          ),
        ),
      ),
    );
  }
}

class _CameraModesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Padding(
            padding: .symmetric(horizontal: 5),
            child: FilledButton.icon(
              icon: Icon(Icons.portrait_rounded),
              label: Text("Portrait"),
              onPressed: () => AndroidHelper.startSamsungCameraWidget(context, AndroidHelper.MODE_PORTRAIT),
            ),
          ),
          Padding(
            padding: .symmetric(horizontal: 5),
            child: FilledButton.icon(
              icon: Icon(Icons.adjust_rounded),
              label: Text("Pro"),
              onPressed: () => AndroidHelper.startSamsungCameraWidget(context, AndroidHelper.MODE_PRO),
            ),
          ),
          Padding(
            padding: .symmetric(horizontal: 5),
            child: FilledButton.icon(
              icon: Icon(Icons.video_camera_front_outlined),
              label: Text("Pro Vid"),
              onPressed: () => AndroidHelper.startSamsungCameraWidget(context, AndroidHelper.MODE_PRO_VIDEO),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShutterRow extends StatefulWidget {
  const _ShutterRow({required this.controller});
  final CameraController controller;

  @override
  State<_ShutterRow> createState() => _ShutterRowState();
}

class _ShutterRowState extends State<_ShutterRow> {
  double scale = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            _currentFocusMode == .auto ? Icons.center_focus_weak_outlined : Icons.center_focus_strong_rounded,
            size: 35
          ),
          tooltip: "Focus mode: ${_currentFocusMode.name}",
          onPressed: () async {
            _currentFocusMode = _currentFocusMode == .auto ? .locked : .auto;
            await _controller.setFocusMode(_currentFocusMode);
            setState(() {});
          },
        ),

        TapRegion(
          onTapInside: (event) async {
            setState(() => scale = 0.8);
            _CameraPageState.instance?.setState(() => _previewScale = 0.95);
            if (Settings.camLockExpoOnHold) {
              await _controller.setExposureMode(.locked);
              setState(() => _currentExpoMode = .locked);
            }
            if (Settings.camLockFocusOnHold) {
              await _controller.setFocusMode(.locked);
              setState(() => _currentFocusMode = .locked);
            }
          },
          onTapUpInside: (event) {
            setState(() => scale = 1);
            _CameraPageState.instance?.setState(() => _previewScale = 1);
          },
          child: AnimatedScale(
            scale: scale,
            duration: Duration(milliseconds: 150),
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: .all(Theme.of(context).colorScheme.tertiaryContainer),
                iconColor: .all(Theme.of(context).colorScheme.tertiary)
              ),
              icon: Icon(Icons.lens_sharp, size: 60),
              onPressed: () async {
                final photo = await widget.controller.takePicture();
                final path = CameraHelper.nameWithDate("Photo");
                await photo.saveTo(path);
                await File(photo.path).delete();            
                showStyledToast("Saved: ${path.substring(path.lastIndexOf(Platform.pathSeparator) + 1)}", context);

                if (Settings.camLockExpoOnHold) {
                  await _controller.setExposureMode(.auto);
                  setState(() => _currentExpoMode = .auto);
                }
                if (Settings.camLockFocusOnHold) {
                  await _controller.setFocusMode(.auto);
                  setState(() => _currentFocusMode = .auto);
                }
                
                if (Settings.camEditCommentAfterPic)
                  (await Photo.fromPath(path)).showEditCommentPopup(context);
            
                await ExifInterfaceOLD.setAttribute(path, ExifTagOLD.TAG_IMAGE_DESCRIPTION, "Taken With Memories Photos");
              },
            ),
          ),
        ),
        
        IconButton(
          icon: Icon(
            _currentExpoMode == .auto ? Icons.exposure_rounded : Icons.lock_outlined,
            size: 35
          ),
          tooltip: "Exposure mode: ${_currentExpoMode.name}",
          onPressed: () async {
            _currentExpoMode = _currentExpoMode == .auto ? .locked : .auto;
            await _controller.setExposureMode(_currentExpoMode);
            setState(() {});
          },
        ),
      ],
    );
  }
}

SliderThemeData cameraSliderTheme(BuildContext context) => SliderThemeData(
  padding: .all(0),
  showValueIndicator: .onDrag,
  valueIndicatorTextStyle: TextStyle(
    fontSize: 18
  ),
  thumbShape: RoundSliderThumbShape(
    elevation: 0,
    pressedElevation: 0,
    enabledThumbRadius: 8
  ),
  thumbColor: Theme.of(context).colorScheme.primary,
  trackHeight: 25,
  activeTrackColor: Theme.of(context).colorScheme.secondaryContainer,
  inactiveTrackColor: Theme.of(context).colorScheme.secondaryContainer,
);
