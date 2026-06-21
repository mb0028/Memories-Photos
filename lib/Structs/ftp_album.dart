import 'dart:convert';
import 'dart:io';
import 'package:ip_go/ip_go.dart';

class FtpAlbum {
  String folderPath;
  String name;
  String password;
  int port;
  bool client;
  List<String> photos = [];

  Future<String?> get ip async => await IpGo.privateIp;

  static const String _nameT = "[NAME]";
  static const String _passwordT = "[PASSWORD]";
  static const String _portT = "[PORT]";
  static const String _clientT = "[CLIENT]";
  static const String _photosT = "[PHOTO]";

  FtpAlbum({required this.folderPath, required this.name, required this.port, required this.password, required this.client});

  Future load() async {
    var file = File("$folderPath${Platform.pathSeparator}.monoP FTP album info.txt");

    if (file.existsSync()) {
      LineSplitter splitter = LineSplitter();
      var settin = file.readAsStringSync();
      var lines = splitter.convert(settin);

      for (var i = 0; i < lines.length; i++) {
        if (lines[i].startsWith(_nameT))
          name = lines[i].split(_nameT)[1];
        if (lines[i].startsWith(_passwordT))
          password = lines[i].split(_passwordT)[1];
        if (lines[i].startsWith(_portT))
          port = int.parse(lines[i].split(_portT)[1]);
        if (lines[i].startsWith(_clientT))
          client = bool.parse(lines[i].split(_clientT)[1]);
        if (lines[i].startsWith(_photosT))
          photos.add(lines[i].split(_photosT)[1]);
      }
    }
  }

  void save() async {
    var file = File("$folderPath${Platform.pathSeparator}.monoP FTP album info.txt");
    await file.create();
    String result = "";

    result += "$_nameT$name\n";
    result += "$_passwordT$password\n";
    result += "$_portT$port\n";
    result += "$_clientT$client";

    for (var path in photos)
      result += "$_photosT$path\n";
    
    await file.writeAsString(result);
  }
}