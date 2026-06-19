import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/ftp_album.dart';
import 'package:memories_photos/monop_text_field.dart';

Future<FtpAlbum?> showNewFtpAlbumeDialog(BuildContext context) async {
  var albumPath = TextEditingController();
  var albumName = TextEditingController();
  var albumPort = TextEditingController();
  var albumPass = TextEditingController();
  bool canceled = true;

  await showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        padding: .all(25),
        width: 500,
        height: 500,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Text(
              "Create New FTP Album",
              textAlign: .center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text("Album Name:\n(Also uses for ftp server username)"),
            MonoPTextField(controller: albumName),
            Text("Folder:"),
            Row(
              spacing: 5,
              children: [
                Expanded(flex: 5, child: MonoPTextField(controller: albumPath),),
                Expanded(
                  child: IconButton.outlined(
                    padding: .all(15),
                    icon: Icon(Icons.folder_shared_outlined),
                    onPressed: () { },
                  ),
                ),
              ],
            ),
            Text("FTP Port:"),
            MonoPTextField(controller: albumPort),
            Text("FTP Password:"),
            MonoPTextField(controller: albumPass),
            SizedBox(height: 10),
            FilledButton(
              child: Text("Create"),
              onPressed: () {
                try {
                  int.parse(albumPort.text);
                  Directory(albumPath.text).createSync(recursive: true);
                  canceled = false;
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e.toString()); //TODO: Show error to user
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
  if (canceled)
    return null;

  return FtpAlbum(
    folderPath: albumPath.text,
    name: albumName.text,
    port: int.parse(albumPort.text),
    password: albumPass.text
  );
}
