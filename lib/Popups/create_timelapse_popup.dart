import 'dart:io';
// import 'package:ffmpeg_kit_flutter_new_video/extensions.dart';
// import 'package:ffmpeg_kit_flutter_new_video/ffmpeg_kit.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Widgets/monop_text_field.dart';
import 'package:memories_photos/settings.dart';

Future<void> showCreateTimelapseDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => _CreateTimelapse(),
  );

  return;
}

class _CreateTimelapse extends StatefulWidget {
  @override
  State<_CreateTimelapse> createState() => _CreateTimelapseState();
}

class _CreateTimelapseState extends State<_CreateTimelapse> {
  var albumPath = TextEditingController();
  int framerate = 15;
  bool showButtons = true;
  String cmd = "";

  @override
  void initState() {
    albumPath.text = Settings.appPath;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cmd == "") // Temporaty disabled Timelapse making
      return Center(child: Text("Coming Soon"));

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer, //TODO: Change it to secondary container
      child: Container(
        padding: .all(25),
        width: 500,
        height: 500,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Text(
              "Create Timelapse",
              textAlign: .center,
              style: TextStyle(
                fontSize: 26,
                fontFamily: Settings.CherryBombOne
              ),
            ),
            SizedBox(height: 10),
            Text("Select the folder you want to make timelapse from it. all jpg photos in folder will be included in timelapse ordered by name"),
            SizedBox(height: 5),
            Text(showButtons ? "Album Path:" : ""),
            SizedBox(height: 10),
            showButtons ? Row(
              spacing: 5,
              children: [
                Expanded(flex: 4, child: MonoPTextField(controller: albumPath)),
                Expanded(
                  child: IconButton.outlined(
                    padding: .all(15),
                    tooltip: "Pickup",
                    icon: Icon(Icons.open_in_new_rounded),
                    onPressed: () async {
                      var t = await FilesystemPicker.openDialog(
                        context: context,
                        rootName: "Internal storage",
                        pickText: "Select Folder",
                        showGoUp: false,
                        fsType: .folder,
                        shortcuts: Platform.isWindows ? [
                          .new(name: "C:", path: .new("C:")),
                          .new(name: "D:", path: .new("D:")),
                          .new(name: "E:", path: .new("E:")),
                          .new(name: "Users", path: .new("C:/Users")),
                          .new(name: "Memories Photos", path: .new(Settings.appPath)),
                        ] : [
                          .new(name: "Internal storage", path: .new("/sdcard/")),
                          .new(name: "DCIM/Memories Photos", path: .new(Settings.appPath)),
                        ],
                      );
                      
                      albumPath.text = t ?? "";
                    },
                  ),
                ),
              ],
            ) : SizedBox(),
            SizedBox(height: 30),
            showButtons ? Slider(
              min: 1, max: 30,
              value: framerate.toDouble(),
              label: "  Framerate: ${framerate.toInt()} ${framerate.toInt() == 15 ? "(Recommended)" : ""}  ",
              showValueIndicator: .alwaysVisible,
              onChanged: (value) => setState(() => framerate = value.toInt()),
            ) : SizedBox(height: 0),
            
            SizedBox(height: 10),
            showButtons ? FilledButton(
              child: Text("Create Timelapse"),
              onPressed: () async {
                try {
                  final t = DateTime.now();
                  setState(() => showButtons = false);
                  String paths = "";
                  for (var file in Directory(albumPath.text).listSync())
                    if (file is File && file.path.endsWith(".jpg"))
                      paths += "file '${file.path}'\n";
                  
                  String imagesListPath = "${Settings.appCache}/ffmpegListOfPhotos.txt";
                  String outFilePath = "${Settings.appPath}/Timelapse ${t.year}-${t.month}-${t.day} ${t.hour}-${t.minute}-${t.second}.mp4";
                  var imagesListFile = File(imagesListPath);
                  await imagesListFile.create(recursive: true);
                  await imagesListFile.writeAsString(paths);

                  cmd = '-f concat -r $framerate -safe 0 -i "$imagesListPath" -vf scale=1080:-1 -b:v 50M "$outFilePath"';
                  setState(() {});
                  // await FFmpegKit.execute(cmd).thenReturnResultOrLogs(
                  //   (_) => outFilePath,
                  // ).then( (result) {
                  //     Navigator.of(context).pop();
                  //     showStyledToast("Saved!\n$result", context, duration: 6);
                  //   }
                  // ).catchError( (error) {
                  //     Navigator.of(context).pop();
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
                  //       body: ListView(
                  //         padding: .all(30),
                  //         children: [
                  //           Text("FFmpeg command failed with error: $error"),
                  //         ],
                  //       ),
                  //     )));
                  //   }
                  // );
                } catch (e) {
                  showStyledToast(e.toString(), context, duration: 5);
                }
              },
            ) : Column(
              spacing: 15,
              children: [
                LinearProgressIndicator(
                  minHeight: 20,
                  borderRadius: .circular(25),
                ),
                Text(
                  "Creating timelapse video using FFmpeg...\n> ffmpeg $cmd",
                  textAlign: .center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
