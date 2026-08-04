// ignore_for_file: invalid_use_of_protected_member

import 'dart:collection';
import 'dart:io';
import 'package:memories_photos/Structs/album_info.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/main.dart';
import 'package:memories_photos/settings.dart';

class MbMediaStore {
  // static File cacheFile = File("${Settings.appCache}/Media.txt");
  static Set<Photo> photos = {};
  static Set<Photo> photosInTrash = {};
  static Map<String, AlbumInfo> albums = {};

  static Future<void> rescanAllPhotos() async {
    List<String> pathsToSearch = Settings.onlyShowDCIM ? [Settings.dcimPath] : Settings.libInclude;
    Set<String> libX = Settings.libExclude.toSet(); // TODO: Better excludes in scanning

    Set<String> photoPaths = {};
    final Map<String, int> albumCounts = {};
    final Map<String, String> albumThumbnails = {};
    SplayTreeSet<Photo> temp = SplayTreeSet((a, b) => b.dateTaken.compareTo(a.dateTaken));
    SplayTreeSet<Photo> tempTrash = SplayTreeSet((a, b) => b.dateTaken.compareTo(a.dateTaken));
    List<FileSystemEntity> np = []; 

    for (var dir in pathsToSearch) {
      np = [Directory(dir)];
      while (np.isNotEmpty) {
        var t = np;
        np = [];
        for (var subdir in t) {
          for (var entity in (subdir as Directory).listSync()) {
            if (!Settings.showHidden && (entity is Directory 
              && !entity.path.contains("${Platform.pathSeparator}."))
              && !libX.contains(entity.path)) {
              np.add(entity);
            }
            else if (entity is File && _isImageFile(entity.path)) {
              final path = entity.path;
              final folder = path.substring(0, path.lastIndexOf(Platform.pathSeparator));
              final isHidden = path.contains("${Platform.pathSeparator}.") && !path.substring(path.lastIndexOf(Platform.pathSeparator) + 1).startsWith(".monoP_trashed_");
              final isTrashed = path.substring(path.lastIndexOf(Platform.pathSeparator) + 1).startsWith(".${Settings.trashFileName}");

              final pii = await Photo.fromPath(path);
              if (isHidden) {
                if (Settings.showHidden)
                  temp.add(pii);
                else continue;
              }
              else if (isTrashed)
                tempTrash.add(pii);
              else
                temp.add(pii);
              photoPaths.add(pii.toString());

              albumCounts[folder] = (albumCounts[folder] ?? 0) + 1;
              albumThumbnails.putIfAbsent(folder, () => path);
            }
          }
        }
      }
    }

    albums = {};
    albumCounts.forEach((folderPath, count) =>
      albums[folderPath] = AlbumInfo(thumbnail: albumThumbnails[folderPath]!, itemsInIt: count));
    // MainAppState.instance?.setState(() {});
    
    photos = temp;
    photosInTrash = tempTrash;
    MainAppState.instance?.setState(() {});
  }

  static Future<Set<Photo>> scanFolderFunky(String dirPath) async {
    SplayTreeSet<Photo> temp = SplayTreeSet((a, b) => b.dateTaken.compareTo(a.dateTaken));
    for (var entity in Directory(dirPath).listSync()) {
      final path = entity.path;
      if (entity is File && _isImageFile(path)) {
        if (path.substring(path.lastIndexOf("/") + 1).startsWith(".")) { // Add to temp if its not hidden
          if (Settings.showHidden)
            temp.add(await Photo.fromPath(path));
        }
        else temp.add(await Photo.fromPath(path));
      }          
    }
    return temp;
  }

  static bool _isImageFile(String path) => path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".jpeg");

}