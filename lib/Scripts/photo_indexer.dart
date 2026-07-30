import 'dart:async';
import 'dart:io';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Structs/album_info.dart';
import 'package:memories_photos/settings.dart';

class PhotoIndexer {
  static List<Photo> photos = [];
  static List<Photo> photosInTrash = [];
  static Map<String, AlbumInfo> albums = {};

  static Future<void> rescanAllPhotos() async {
    final stopwatch = Stopwatch()..start();
    List<String> pathsToSearch = Settings.onlyShowDCIM ? [Settings.dcimPath] : Settings.libInclude;
    Set<String> libX = Settings.libExclude.toSet(); // TODO: Better excludes in scanning
    
    albums = {};
    List<String> photoPaths = [];
    final Map<String, int> albumCounts = {};
    final Map<String, String> albumThumbnails = {};
    for (var dir in pathsToSearch)
      await for (final entity in Directory(dir).list(recursive: true)) {
        if (entity is File && _isImageFile(entity.path)) {
          final path = entity.path;
          final folder = path.substring(0, path.lastIndexOf(Platform.pathSeparator));
          if (libX.contains(folder)) continue;
          photoPaths.add(path);
          albumCounts[folder] = (albumCounts[folder] ?? 0) + 1;
          albumThumbnails.putIfAbsent(folder, () => path);
        }
      }
    
    albumCounts.forEach((folderPath, count) =>
      albums[folderPath] = AlbumInfo(thumbnail: albumThumbnails[folderPath]!, itemsInIt: count));
    
    photos = [];
    photosInTrash = [];
    List<Photo> temp = [];
    
    const int chunk = 50;
    for (var i = 0; i < photoPaths.length; i += chunk) {
      final end = (i + chunk < photoPaths.length) ? i + chunk : photoPaths.length;
      final batch = photoPaths.sublist(i, end);
      
      final photosChunk = await Future.wait(
        batch.map((path) => Photo.fromPath(path))
      );

      for (Photo p in photosChunk) {
        final path = p.path;
        final isHidden = path.substring(path.lastIndexOf("/") + 1).startsWith(".");
        final isTrashed = path.contains("${Platform.pathSeparator}.monoP_trashed_");

        if (isHidden) { // Add to temp if its not hidden
          if (Settings.showHidden) {
            temp.add(p);
          }
        }
        else if (isTrashed) // If is in trash add to trashed list
          photosInTrash.add(p);
        else
          temp.add(p);
      }
    }
    
    temp.sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
    photosInTrash.sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
    photos = temp;

    Settings.log("Photos scan finished in ${stopwatch.elapsedMilliseconds}ms",
      moreInfo: "${photos.length} Photos  |  ${photosInTrash.length} In trash  |  ${albums.length} Albums",
      sender: PhotoIndexer
    );
  }

  static Future<List<Photo>> scanFolderFunky(String dirPath) async {
    List<Photo> temp = [];
    await for (var entity in Directory(dirPath).list()) {
      final path = entity.path;
      if (entity is File && _isImageFile(path)) {
        if (path.substring(path.lastIndexOf("/") + 1).startsWith(".")) { // Add to temp if its not hidden
          if (Settings.showHidden) {
            temp.add(await Photo.fromPath(path));
          }
        }
        else temp.add(await Photo.fromPath(path));
      }          
    }
      
    temp.sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
    return temp;
  }

  static bool _isImageFile(String path) => path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".jpeg");

}
