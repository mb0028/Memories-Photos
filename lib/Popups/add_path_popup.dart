
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Widgets/monop_text_field.dart';
import 'package:memories_photos/settings.dart';

Future<String?> showAddPathDialog(BuildContext context) async {
  var path = TextEditingController(text: Platform.isAndroid ? "/sdcard/" : "");
  bool canceled = true;

  await showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      child: Container(
        padding: .all(25),
        width: 500,
        height: 260,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Text(
              "Add Path",
              textAlign: .center,
              style: TextStyle(
                fontSize: 22,
                fontFamily: Settings.CherryBombOne
              ),
            ),
            SizedBox(height: 10),
            Text("Path:"),
            SizedBox(height: 10),
            MonoPTextField(controller: path),
            SizedBox(height: 10),
            FilledButton.icon(
              label: Text("Add"),
              icon: Icon(Icons.folder_shared_outlined),
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
