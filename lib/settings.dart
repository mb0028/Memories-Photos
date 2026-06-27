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
  static String dcimPath = Platform.isAndroid
    ? "/sdcard/DCIM"
    : "C:${Platform.pathSeparator}Users${Platform.pathSeparator}mb28${Platform.pathSeparator}Desktop"; // Temporary. TODO

  static File settingsFile = File("$appPath${Platform.pathSeparator}Settings${Platform.pathSeparator}Settings.txt");

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  static int gridScale = 120;
  static int recentsCount = 20;
  static int specialSectionsCount = 15;
  static int maxUndoCount = 10;
  static bool showHidden = false;
  static bool trashInstead = false;
  static bool onlyShowDCIM = false;

  static List<String> libInclude = [];
  static List<String> libExclude = [];
  static List<String> favorites = [];
  static List<String> archived = [];

  static Future<void> load() async {
    if (await settingsFile.exists()) {
      var splitter = LineSplitter();
      var data = splitter.convert(await settingsFile.readAsString());

      for (var line in data) {
        if (line.startsWith("[LIB_I]"))
          libInclude.add(line.split("[LIB_I]")[1]);
        else if (line.startsWith("[LIB_X]"))
          libExclude.add(line.split("[LIB_X]")[1]);
        else if (line.startsWith("[FAV]") && await File(line.split("[FAV]")[1]).exists())
          favorites.add(line.split("[FAV]")[1]);
        else if (line.startsWith("[ARC]") && await File(line.split("[ARC]")[1]).exists())
          archived.add(line.split("[ARC]")[1]);
        else if (line.startsWith("[GS]"))
          gridScale = int.parse(line.split("[GS]")[1]);
        else if (line.startsWith("[RC]"))
          recentsCount = int.parse(line.split("[RC]")[1]);
        else if (line.startsWith("[SSC]"))
          specialSectionsCount = int.parse(line.split("[SSC]")[1]);
        else if (line.startsWith("[MUC]"))
          maxUndoCount = int.parse(line.split("[MUC]")[1]);
        else if (line.startsWith("[SH]"))
          showHidden = bool.parse(line.split("[SH]")[1]);
        else if (line.startsWith("[TI]"))
          trashInstead = bool.parse(line.split("[TI]")[1]);
        else if (line.startsWith("[OSDCIM]"))
          onlyShowDCIM = bool.parse(line.split("[OSDCIM]")[1]);
      }
    }
    else {
      await settingsFile.create(recursive: true);
      libInclude.add(Platform.isAndroid? "/sdcard/DCIM" : "C:/Users/mb28/Pictures"); // TODO: change windows path. its temporary
      save();
    }
  }

  static void save() async {
    String data = "[SETTINGS]\n";
    data += "[GS]$gridScale\n";
    data += "[RC]$recentsCount\n";
    data += "[SSC]$specialSectionsCount\n";
    data += "[MUC]$maxUndoCount\n";
    data += "[SH]$showHidden\n";
    data += "[TI]$trashInstead\n";
    data += "[OSDCIM]$onlyShowDCIM\n";

    for (var i in libInclude)
      data += "[LIB_I]$i\n";
    for (var i in libExclude)
      data += "[LIB_X]$i\n";
    for (var i in favorites)
      data += "[FAV]$i\n";
    for (var i in archived)
      data += "[ARC]$i\n";

    await settingsFile.writeAsString(data);
  }

}