import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/ftp_album.dart';
import 'package:memories_photos/Widgets/monop_text_field.dart';

Future<FtpAlbum?> addNewFtpAlbumDialog(BuildContext context) async {
  var albumPath = TextEditingController();
  var albumName = TextEditingController();
  var albumPort = TextEditingController();
  var albumPass = TextEditingController();
  bool canceled = true;

  albumPath.text = Platform.isAndroid ? "/sdcard/DCIM/Memories Photos" : "";

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
              "Add FTP Album",
              textAlign: .center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text("Album/Host name:"),
            MonoPTextField(controller: albumName),
            Text("Create in:"),
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
            Text("FTP Port:"),
            MonoPTextField(controller: albumPort),
            Text("FTP Password:"),
            MonoPTextField(controller: albumPass),
            SizedBox(height: 10),
            FilledButton(
              child: Text("Add"),
              onPressed: () {
                try {
                  int.parse(albumPort.text);
                  Directory(albumPath.text + Platform.pathSeparator + albumName.text).createSync(recursive: true);
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

  var a = FtpAlbum(
    folderPath: albumPath.text + Platform.pathSeparator + albumName.text,
    name: albumName.text,
    port: int.parse(albumPort.text),
    password: albumPass.text,
    client: true
  );
  a.save();
  return a;
}
