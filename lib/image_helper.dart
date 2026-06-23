import 'package:flutter/services.dart';

class ImageHelper {
  static const channel = MethodChannel("mb28.monoP.camera/camera_channel");

  static Future<void> takePicture() async {
    // final picker = ImagePicker();
    // final XFile? photo = await picker.pickImage(
    //   source: ImageSource.camera,
    //   imageQuality: 100,
    // );
    // if (photo != null) {
    //   final t = DateTime.now();
    //   var time = "${t.year}${t.month}${t.day} ${t.hour}${t.minute}${t.second}.jpg";
    //   await photo.saveTo(Settings.appPath + Platform.pathSeparator + time);
    //   await File(photo.path).delete();
    // }
    
  }

  // static Future<String> _takePictureAndroid() async {
  //   if (Platform.isWindows) return "";
  //   try {
  //     final result = await channel.invokeMethod<String>("takePictureAndroid");
  //     return result!;
  //   } on Exception {
  //     return "";
  //   }
  // }

}