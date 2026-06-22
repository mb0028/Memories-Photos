import 'dart:io';
import 'package:memories_photos/Structs/ftp_album.dart';
import 'package:memories_photos/Structs/photo.dart';

class PhotoIndexer {
  static var slash = Platform.pathSeparator;

  static List<String> commonPhotoDirs = Platform.isAndroid
    ? ["${slash}sdcard${slash}DCIM", "${slash}sdcard${slash}Download"] // Temporary TODO
    : ["C:${slash}Users${slash}mb28${slash}Pictures"]; // Temporary TODO

  static List<Photo> photos = [];
  // static Map<Photo, DateTime> photosT = <Photo, DateTime>{};
  static List<String> albums = [];
  static List<FtpAlbum> ftpAlbums = [];

  static void startCa() async {
    photos = [];
    albums = [];
    List<Photo> temp = [];

    for (var dir in commonPhotoDirs)
      for (var file in Directory(dir).listSync(recursive: true)) {
        String path = file.path;
        if (path.contains(".png") || path.contains(".jpg") || path.contains(".jpeg"))
        {
          temp.add(Photo(path: path));
          String folder = path.substring(0, path.lastIndexOf(Platform.pathSeparator));
          if (!albums.contains(folder))
            albums.add(folder);
        }
        else if (path.contains(".monoP FTP album info.txt")) {
          var albuu = FtpAlbum(folderPath: path.substring(0, path.lastIndexOf(Platform.pathSeparator)),
            name: '', port: 0, password: '', client: false);
          albuu.load();
          ftpAlbums.add(albuu);
        }
      }
    
    for (var dirPathF in ftpAlbums)
      if (albums.contains(dirPathF.folderPath))
        albums.remove(dirPathF.folderPath);
      
    List<DateTime> times = [];
    for (var p in photos)
      times.add(await p.dateTakenOrFileTime); //TODO: Add exif datetime tag

    temp.sort((a, b) => File(b.path).lastModifiedSync().compareTo(File(a.path).lastModifiedSync()));
    
    photos = temp;
  }

  static List<Photo> getPhotosIn(String path) {
    List<Photo> temp = [];
    for (var file in Directory(path).listSync())
      if (file.path.contains(".png") || file.path.contains(".jpg") || file.path.contains(".jpeg"))
        temp.add(Photo(path: file.path));
    temp.sort((a, b) => File(b.path).lastModifiedSync().compareTo(File(a.path).lastModifiedSync()));
    return temp;
  }

  static String? getFolderThumb(String path) {
    for (var file in Directory(path).listSync())
      if (file.path.contains(".png") || file.path.contains(".jpg") || file.path.contains(".jpeg"))
        return file.path;
    return null;
  }

  static int getFolderPhotosCount(String path) {
    int result = 0;
    for (var file in Directory(path).listSync())
      if (file.path.contains(".png") || file.path.contains(".jpg") || file.path.contains(".jpeg"))
        result++;
    return result;
  }

}