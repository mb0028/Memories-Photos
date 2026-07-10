// ignore_for_file: empty_catches

import 'dart:io';
import 'package:flutter/services.dart';

class AndroidHelper {
  static const channel = MethodChannel("mb28.monoP.helper/helper_channel");

  static Future<bool> isExternalStorageManager() async {
    if (Platform.isWindows) return true;
    try {
      final result = await channel.invokeMethod<bool>("isExternalStorageManager");
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<void> openAllFilesAccess() async {
    try {
      await channel.invokeMethod("openAllFilesAccess");
    } on PlatformException {}
  }

  static void openWithMaps(String lat, String long) async {
    try {
      await channel.invokeMethod("openWithMaps", {"lat": lat, "long": long});
    } on PlatformException {}
  }



}