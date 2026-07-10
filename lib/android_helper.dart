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
    if (Platform.isWindows) return;
    try {
      await channel.invokeMethod<bool>("setAttribute");
    } on PlatformException {}
  }



}