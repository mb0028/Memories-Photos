import 'package:flutter/services.dart';

class ExifInterface {
  static const channel = MethodChannel("mb28.monoP.exif/exif_channel");

  static Future<String> getAttribute(String path, String tag) async {
    try {
      final result = await channel.invokeMethod<String>("getAttribute",
        {"path": path, "tag": tag});
      return result!;
    } on PlatformException {
      return "";
    }
  }

  static Future<String> setAttribute(String path, String tag, String value) async {
    try {
      final result = await channel.invokeMethod<bool>("setAttribute",
        {"path": path, "tag": tag, "value": value});
      return 'Battery level at $result % .';
    } on PlatformException catch (e) {
      return "Failed to get battery level: '${e.message}'.";
    }
  }

  static Future<Map<String?, String?>> getUsefulExif(String path) async {
    try {
      Map<String?, String?> result = await channel.invokeMethod<Map<String?, String?>>("getUsefulExif",
        {"path": path}) as Map<String?, String?>;
      return result;
    } on PlatformException {
      return <String?, String?> {};
    }
  }

}