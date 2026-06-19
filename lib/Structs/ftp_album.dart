
import 'package:ip_go/ip_go.dart';

class FtpAlbum {
  final String folderPath;
  final String name;
  final int port;
  final String password;

  Future<String?> get ip async => await IpGo.privateIp;

  FtpAlbum({required this.folderPath, required this.name, required this.port, required this.password});
}