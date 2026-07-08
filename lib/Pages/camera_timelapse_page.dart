import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/main.dart';
import 'package:memories_photos/settings.dart';

class CameraTakeTimelapsePage extends StatefulWidget {
  const CameraTakeTimelapsePage({super.key});
  @override
  State<CameraTakeTimelapsePage> createState() => _CameraTakeTimelapsePageState();
}

class _CameraTakeTimelapsePageState extends State<CameraTakeTimelapsePage> {
  late CameraController controller;
  bool timelapseStarted = false;
  String timelapseSavePath = "${Settings.appPath}/";
  int captureInterval = 15;
  int captures = 0;
  String lastCapturePath = "";
  bool showCameraPreview = true;
  Orientation  orientation = .portrait;

  double time = 0;
  double timeMS = 0;

  void updateTime() async {
    while (timelapseStarted) {
      await Future.delayed(Duration(milliseconds: 50));
      timeMS += 50;
      setState(() => time = (timeMS / 1000) / captureInterval);
    }
  }

  void initCamera(int cam) {
    controller = CameraController(cameras[cam], ResolutionPreset.max);
    controller
      .initialize()
      .then((_) {
        if (!mounted)
          return;
        controller.unlockCaptureOrientation();
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

  void startTimelapse() async {
    controller.lockCaptureOrientation();
    timelapseStarted = true;
    captures = 0;
    final t = DateTime.now();
    timelapseSavePath = "${Settings.appPath}/Timelapse ${t.year}-${t.month}-${t.day} ${t.hour}-${t.minute}-${t.second}";
    showStyledToast("Timelapse started:\n- Capture interval: $captureInterval\n- Path: $timelapseSavePath", context);
    setState(() {});
    updateTime();

    while (timelapseStarted) {
      if (timelapseStarted) {
        time = 0;
        timeMS = 0;
        captures++;
        setState(() => lastCapturePath = "$timelapseSavePath/Take $captures.jpg");

        var photo = await controller.takePicture();
        await File(lastCapturePath).create(recursive: true);
        await photo.saveTo(lastCapturePath);
        await File(photo.path).delete();
      }
      await Future.delayed(Duration(seconds: captureInterval));
    }
  }

  void endTimelapse() async {
    timelapseStarted = false;
    captures = 0;
    controller.unlockCaptureOrientation();
    setState(() {});
    showStyledToast("Timelapse finished!", context);
    Future.delayed(Duration(milliseconds: 500), () {
      time = 0;
      timeMS = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    KeepScreenOn.turnOn();
    initCamera(0);
  }

  @override
  void dispose() {
    controller.dispose();
    KeepScreenOn.turnOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.orientationOf(context);
    if (!controller.value.isInitialized) {
      return CircularProgressIndicator();
    }
    return Scaffold(
      backgroundColor: timelapseStarted ? Colors.black : Theme.of(context).colorScheme.surface,
      body: PopScope(
        canPop: !timelapseStarted,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop)
            showStyledToast("Stop timelapse before exiting.", context);
        },
        child: Container(
          padding: orientation == .portrait ? MediaQuery.paddingOf(context) : .all(0),
          child: Stack(
            alignment: .topCenter,
            children: [
              showCameraPreview ? CameraPreview(controller) : SizedBox(height: 500),
              Column(
                mainAxisAlignment: .spaceBetween,
                children: [
                  SizedBox(height: orientation == .portrait ? 500 : 130),
                  timelapseStarted == false ? SizedBox(
                    height: 140,
                    width: orientation == .portrait ? null : 400,
                    child: Column(
                      spacing: 5,
                      children: [
                        SizedBox(
                          height: 35,
                          child: ListView.builder(
                            itemCount: cameras.length,
                            scrollDirection: .horizontal,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => cameras[index].lensDirection != .front ? Padding(
                              padding: .symmetric(horizontal: 5),
                              child: OutlinedButton(
                                onPressed: () => initCamera(index), 
                                child: Text(index == 2 ? "Wide" : "Normal")
                              ),
                            ) : SizedBox(),
                          ),
                        ),
                        ListTile(
                          title: Padding(
                            padding: .only(bottom: 10),
                            child: Text("Capture Interval:"),
                          ),
                          trailing: Text("${captureInterval}s", style: TextStyle(fontSize: 28)),
                          subtitle: Slider(
                            min: 3,
                            max: 60,
                            value: captureInterval.toDouble(),
                            onChanged: (value) => setState(() => captureInterval = value.toInt()),
                          ),
                        ),
                      ],
                    ),
                  )
                  
                  : Padding(
                    padding: .symmetric(horizontal: 15),
                    child: Text(
                      "$lastCapturePath\n- $captures photo${captures > 1 ? "s" : ""} taken\n- Interval: $captureInterval",
                      textAlign: .center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface
                      ),
                    ),
                  ),
              
                  Row(
                    mainAxisAlignment: .center,
                    spacing: timelapseStarted ? 15 : 0,
                    children: [
                      Stack(
                        alignment: .center,
                        children: [
                          _UntilNextTake(time: time),
                          IconButton.filledTonal(
                            icon: Icon(timelapseStarted ? Icons.stop_rounded : Icons.timelapse_outlined, size: 60),
                            tooltip: "Start/Stop Timelapse",
                            onPressed: () {
                              setState(() {
                                if (!timelapseStarted)
                                  startTimelapse();
                                else endTimelapse();
                              });
                            },
                          ),
                        ],
                      ),
                      timelapseStarted ? IconButton.filledTonal(
                        icon: Icon(showCameraPreview ? Icons.gps_off_sharp : Icons.camera_alt_rounded, size: 60),
                        tooltip: "Show/Hide Camera Perview",
                        onPressed: () {
                          setState(() => showCameraPreview = !showCameraPreview);
                        },
                      ) : SizedBox(width: 0, height: 0),
                    ],
                  ),
              
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UntilNextTake extends StatelessWidget {
  final double time;
  const _UntilNextTake({required this.time});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 2.5,
      child: CircularProgressIndicator(
        value: time,
        strokeWidth: 2,
        color: Theme.of(context).colorScheme.tertiaryContainer,
      ),
    );
  }
}
