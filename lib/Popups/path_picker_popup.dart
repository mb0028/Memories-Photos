import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/monop_dialog.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Widgets/monop_text_field.dart';
import 'package:memories_photos/settings.dart';

Future<String?> showPathPickerDialog(BuildContext context) async {
  var path = TextEditingController(text: Platform.isAndroid ? "/sdcard/" : "");
  bool picked = await showMonoPDialog(
    context,
    title: "Select Path",
    ok: "Select",
    cancel: "Cancel",
    child: Column(
      spacing: 10,
      children: [
        Text("Path:"),
        Row(
          spacing: 5,
          children: [
            Expanded(flex: 4, child: MonoPTextField(controller: path, maxLines: 2)),
            Expanded(
              child: IconButton.outlined(
                padding: .symmetric(vertical: 30),
                icon: Icon(Icons.open_in_new_rounded),
                tooltip: "Pickup",
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
                  path.text = t ?? "";
                }, //TODO
              ),
            ),
          ],
        ),
      ],
    )
  );

  if (picked) {
    if (FileSystemEntity.isDirectorySync(path.text) && Directory(path.text).existsSync()) {
      return Platform.isAndroid
      ? path.text.replaceAll(String.fromCharCode(0x005C), "/") // 0x005C is backslash
      : path.text.replaceAll("/", Platform.pathSeparator);
      }
    else showStyledToast("Folder is not exists (┬┬﹏┬┬)", context);
  }
  return null;
}
