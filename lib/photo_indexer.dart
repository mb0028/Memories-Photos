import 'dart:io';
import 'package:memories_photos/Structs/photo.dart';

class PhotoIndexer {
  static List<String> commonPhotoDirs = Platform.isAndroid
    ? ["/sdcard"] // Temporary TODO
    : ["C:/Users/mb28/Pictures"]; // Temporary TODO

  static List<Photo> ca = [];

  static void startCa() {
    ca = [];
    List<Photo> temp = [];

    for (var dir in commonPhotoDirs)
      for (var file in Directory(dir).listSync(recursive: true))
        if (file.path.contains(".png") || file.path.contains(".jpg") || file.path.contains(".jpeg"))
          temp.add(Photo(path: file.path));

    ca = temp;
  }
}