// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

class Settings {
  static const String LexendDeca = "LexendDeca";
  static const String ElmsSans = "ElmsSans";
  static const String CherryBombOne = "CherryBombOne";

  static String get appPath {
    var path = Platform.isAndroid
      ? "/sdcard/DCIM/Memories Photos"
      : "E:${Platform.pathSeparator}"; // Temporary. TODO
    Directory(path).createSync(recursive: true);
    return path;
  } 

  static String get appCache {
    var path = Platform.isAndroid
      ? "/sdcard/DCIM/Memories Photos/.temp"
      : "E:${Platform.pathSeparator}.temp${Platform.pathSeparator}"; // Temporary. TODO
    Directory(path).createSync(recursive: true);
    return path;
  } 

  static File settingsFile = File("$appPath/_Settings.txt");

  static int gridScale = 120;
  static int recentsCount = 20;
  static int specialSectionsCount = 15;
  static int maxUndoCount = 10;
  static bool showHidden = true;
  static bool trashInstead = true;

  static List<String> libInclude = [];
  static List<String> libExclude = [];
  static List<String> favorites = [];
  static List<String> archived = [];

  static Future<Settings> load() async {
    var settings = Settings();

    if (await settingsFile.exists()) {
      var splitter = LineSplitter();
      var data = splitter.convert(await settingsFile.readAsString());

      for (var line in data) {
        if (line.startsWith(""))
          gridScale = int.parse(line.split("")[0]);
      }
    }
    else {
      await settingsFile.create(recursive: true);
      save();
    }

    return settings;
  }

  static void save() {

  }

}