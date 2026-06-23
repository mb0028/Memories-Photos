import 'dart:io';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Structs/album_info.dart';

class PhotoIndexer {
  static var slash = Platform.pathSeparator;

  static List<String> commonPhotoDirs = Platform.isAndroid
    ? ["${slash}sdcard${slash}DCIM", "${slash}sdcard${slash}Download"] // Temporary TODO
    : ["C:${slash}Users${slash}mb28${slash}Pictures"]; // Temporary TODO

  static List<Photo> photos = [];
  static Map<String, AlbumInfo> albums = <String, AlbumInfo>{};

  static Future startCache() async {
    photos = [];
    albums = <String, AlbumInfo>{};
    List<Photo> temp = [];

    for (var dir in commonPhotoDirs)
      for (var file in Directory(dir).listSync(recursive: true)) {
        String path = file.path;
        if (path.contains(".png") || path.contains(".jpg") || path.contains(".jpeg"))
        {
          temp.add(await Photo.fromPath(path));
          String folder = path.substring(0, path.lastIndexOf(Platform.pathSeparator));
          if (!albums.containsKey(folder))
            albums[folder] = AlbumInfo(thumbnail: path, itemsInIt: _getFolderPhotosCount(folder));
        }
      }

    temp.sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
    photos = temp;
  }



  static Future<List<Photo>> getFolderPhotos(String path) async {
    List<Photo> temp = [];
    for (var file in Directory(path).listSync())
      if (file.path.contains(".png") || file.path.contains(".jpg") || file.path.contains(".jpeg"))
        temp.add(await Photo.fromPath(file.path));
    temp.sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
    return temp;
  }

  static int _getFolderPhotosCount(String path) { //TODO Impprove performance
    int result = 0;
    for (var file in Directory(path).listSync())
      if (file.path.contains(".png") || file.path.contains(".jpg") || file.path.contains(".jpeg"))
        result++;
    return result;
  }

}
