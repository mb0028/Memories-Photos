// ignore_for_file: constant_identifier_names, empty_catches

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories_photos/Popups/toast.dart';

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

  static void startActivityClass(String package, String classN) async {
    try {
      await channel.invokeMethod("startActivityClass", {"class": classN, "package": package});
    } on PlatformException{}
  }

  static const String MODE_PORTRAIT = "com.sec.android.app.camera.shootingmode.livefocus";
  static const String MODE_PRO = "com.sec.android.app.camera.shootingmode.pro";
  static const String MODE_PRO_VIDEO = "com.sec.android.app.camera.shootingmode.provideo";
  static void startSamsungCameraWidget(BuildContext context, String mode) async {
    try {
      await channel.invokeMethod("startSamsungCameraWidget", {"mode": mode});
    } on PlatformException {
      showStyledToast("Samsung Camera (com.sec.android.app.camera) is not installed!", context, duration: 5);
    }
  }
  static void startSamsungCameraWidgetSettings(BuildContext context) async {
    try {
      await channel.invokeMethod("startSamsungCameraWidgetSettings");
    } on PlatformException catch (e) {
      showStyledToast("Samsung Camera (com.sec.android.app.camera) is not installed!\n\n$e", context, duration: 5);
    }
  }

}