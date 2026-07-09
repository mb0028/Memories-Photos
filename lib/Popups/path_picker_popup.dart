import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Widgets/monop_text_field.dart';
import 'package:memories_photos/settings.dart';

Future<String?> showPathPickerDialog(BuildContext context) async {
  var path = TextEditingController(text: Platform.isAndroid ? "/sdcard/" : "");
  bool canceled = true;

  await showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      child: Container(
        padding: .all(25),
        width: 500,
        height: 270,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Text(
              "Pickup Path",
              textAlign: .center,
              style: TextStyle(
                fontSize: 22,
                fontFamily: Settings.CherryBombOne
              ),
            ),
            SizedBox(height: 10),
            Text("Path:"),
            SizedBox(height: 10),
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
                        rootDirectory: Platform.isAndroid ? Directory("/sdcard/") : null,
                        shortcuts: Platform.isWindows ? [
                          .new(name: "C:", path: .new("C:")),
                          .new(name: "D:", path: .new("D:")),
                          .new(name: "E:", path: .new("E:")),
                          .new(name: "Users", path: .new("C:/Users")),
                        ] : [],

                      );
                      path.text = t ?? "";
                    }, //TODO
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            FilledButton(
              child: Text("Ok"),
              onPressed: () {
                if (FileSystemEntity.isDirectorySync(path.text) && Directory(path.text).existsSync()) {
                  canceled = false;
                  Navigator.of(context).pop();
                }
                else showStyledToast("Folder is not exists (┬┬﹏┬┬)", context);
              },
            ),  
          ],
        ),
      ),
    ),
  );

  if (canceled)
    return null;

  return Platform.isAndroid
    ? path.text.replaceAll(String.fromCharCode(0x005C), "/") // 0x005C is backslash
    : path.text.replaceAll("/", Platform.pathSeparator);
}
