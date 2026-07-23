import 'dart:async';
import 'dart:io';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Structs/album_info.dart';
import 'package:memories_photos/settings.dart';

class PhotoIndexer {
  static List<Photo> photos = [];
  static List<Photo> photosInTrash = [];
  static Map<String, AlbumInfo> albums = {};

  // TODO: This method needs full remake. its so slow and messy...
  static Future<void> startCache() async {
    photos = [];
    photosInTrash = [];
    albums = {};

    var stopwatch = Stopwatch()..start();
    List<Photo> temp = [];
    List<String> pathsToSearch = Settings.onlyShowDCIM ? [Settings.dcimPath] : Settings.libInclude;
    List<FileSystemEntity> np = []; 

    for (var dir in pathsToSearch) {
      np = [Directory(dir)];
      while (np.isNotEmpty) {
        var t = np;
        np = [];
        for (var subdir in t) {
          stopwatch.reset();
          for (var fileSysEnti in (subdir as Directory).listSync()) {
            if (!Settings.showHidden && (fileSysEnti is Directory 
              && !fileSysEnti.path.contains("${Platform.pathSeparator}."))
              && !Settings.libExclude.contains(fileSysEnti.path)) {
              np.add(fileSysEnti);
            }
            else if (fileSysEnti is File) {
              String path = fileSysEnti.path;
              if (path.contains(".png") || path.contains(".jpg") || path.contains(".jpeg"))
              {
                var p = await Photo.fromPath(path);

                // 1. Add to temp if its not hidden
                temp.add(p);
                if (!Settings.showHidden && path.startsWith("."))
                  temp.removeLast();

                // 2. Add to photosInTrash
                if (path.contains("${Platform.pathSeparator}.monoP_trashed_")) {
                  photosInTrash.add(p);
                  if (temp.contains(p))
                    temp.remove(p);
                }
                
                // 3. Add the folder to folders list if already not
                String folder = path.substring(0, path.lastIndexOf(Platform.pathSeparator));
                if (!albums.containsKey(folder))
                  albums[folder] = AlbumInfo(thumbnail: path, itemsInIt: _getFolderPhotosCount(folder));
              }
            }
          }
          print("--| PhotoIndexer: Last folder scanned:\n     Path: $subdir\n      In: ${stopwatch.elapsed}\n");
        }
      }
    }
    stopwatch.stop();
    
    temp.sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
    photosInTrash.sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
    photos = temp;
  }

  static Future<List<Photo>> getFolderPhotos(String path) async {
    List<Photo> temp = [];
    for (var file in Directory(path).listSync())
      if (file.path.endsWith(".png") || file.path.endsWith(".jpg") || file.path.endsWith(".jpeg")) {
        temp.add(await Photo.fromPath(file.path));
      }
    temp.sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
    return temp;
  }

  static int _getFolderPhotosCount(String path) { //TODO Improve performance
    int result = 0;
    for (var file in Directory(path).listSync())
      if (file.path.endsWith(".png") || file.path.endsWith(".jpg") || file.path.endsWith(".jpeg"))
        result++;
    return result;
  }

}
