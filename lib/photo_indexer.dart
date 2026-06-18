import 'dart:io';

class PhotoIndexer {
  static List<String> ca = [];

  static void startCa() {
    ca = [];
    List<String> temp = [];
    var pics = Directory("C:/Users/mb28/Pictures").listSync(recursive: true);

    for (var file in pics) 
      if (file.path.contains(".png") || file.path.contains(".jpg") || file.path.contains(".jpeg"))
        temp.add(file.path);

    ca = temp;
  }
}