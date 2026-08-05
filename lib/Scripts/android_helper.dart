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
      final latS = lat.replaceAll('/', ',').split(',');
      final longS = long.replaceAll('/', ',').split(',');

      double latPos = (double.parse(latS[0]) / double.parse(latS[1])) + ((double.parse(latS[2]) / double.parse(latS[3])) / 60) + ((double.parse(latS[4]) / double.parse(latS[5])) / 3600);
      double longPos = (double.parse(longS[0]) / double.parse(longS[1])) + ((double.parse(longS[2]) / double.parse(longS[3])) / 60) + ((double.parse(longS[4]) / double.parse(longS[5])) / 3600);

      await channel.invokeMethod("openWithMaps", {"lat": latPos.toString(), "long": longPos.toString()});
    } on PlatformException {}
  }

}