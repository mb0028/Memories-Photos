import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memories_photos/Pages/More/camera_page.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/settings.dart';

class CameraHelper {
  static Future<void> takePicture(BuildContext context) async {
    if (Settings.inAppCamera && Platform.isAndroid) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraPage()));
      return;
    }
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    if (photo != null) {
      final t = DateTime.now();
      var time = "Photo ${t.year}-${t.month}-${t.day} ${t.hour}-${t.minute}-${t.second}.jpg";
      await photo.saveTo(Settings.appPath + Platform.pathSeparator + time);
      await File(photo.path).delete();
    }
  }

  static Future<void> saveImage(Uint8List photo, BuildContext context, {String name = "Photo"}) async {
    final path = nameWithDate(name);
    await File(path).writeAsBytes(photo);
    showStyledToast("Saved in: ${path.replaceFirst("/sdcard/", '')}", context);
  }

  static String nameWithDate(String name) {
    final t = DateTime.now();
    final time = "$name ${t.year}-${t.month}-${t.day} ${t.hour}-${t.minute}-${t.second}.jpg";
    return Settings.appPath + Platform.pathSeparator + time;
  }
}
