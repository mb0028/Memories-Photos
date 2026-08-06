import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Scripts/camera_helper.dart';
import 'package:memories_photos/Structs/photo.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, required this.photo});
  final Photo photo;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late Uint8List image;
  final cctrl = CropController();

  @override
  void initState() {
    image = File(widget.photo.path).readAsBytesSync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Crop(
        image: image,
        controller: cctrl,
        onCropped: (result) async {
          if (result is CropSuccess)
            CameraHelper.saveImage(image, context, name: "Edited");
        }
      ),

      bottomNavigationBar: Padding(
        padding: .all(15).add(.only(bottom: MediaQuery.paddingOf(context).bottom)),
        child: Row(
          mainAxisAlignment: .center,
          spacing: 5,
          children: [
            FilledButton(
              child: Text("Crop"),
              onPressed: () => cctrl.crop(),
            ),
          ],
        ),
      ),
    );
  }
}
