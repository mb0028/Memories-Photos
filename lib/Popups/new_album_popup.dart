import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Widgets/monop_text_field.dart';

Future<String?> showNewAlbumDialog(BuildContext context) async {
  var albumPath = TextEditingController();
  var albumName = TextEditingController();
  bool canceled = true;

  albumPath.text = Platform.isAndroid ? "/sdcard/DCIM/" : "";

  await showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        padding: .all(25),
        width: 500,
        height: 400,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Text(
              "Create New Album",
              textAlign: .center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text("Album Name:"),
            MonoPTextField(controller: albumName),
            Text("Path:"),
            Row(
              spacing: 5,
              children: [
                Expanded(flex: 4, child: MonoPTextField(controller: albumPath),),
                Expanded(
                  child: IconButton.outlined(
                    padding: .all(15),
                    icon: Icon(Icons.folder_shared_outlined),
                    onPressed: () { },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            FilledButton(
              child: Text("Create"),
              onPressed: () {
                try {
                  Directory(albumPath.text + Platform.pathSeparator + albumName.text).createSync(recursive: true);
                  canceled = false;
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e.toString()); //TODO: Show error to user
                }
              },
            ),
            Text("Note: for now, empty albums are not shows in the app so wait for new updates!"),
          ],
        ),
      ),
    ),
  );
  if (canceled)
    return null;

  return albumPath.text;
}
