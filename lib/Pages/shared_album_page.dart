import 'package:flutter/material.dart';
import 'package:ftp_server/file_operations/file_operations.dart';
import 'package:ftp_server/file_operations/physical_file_operations.dart';
import 'package:ftp_server/ftp_server.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:memories_photos/Pages/photos_page.dart';
import 'package:memories_photos/Structs/ftp_album.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/photo_indexer.dart';
import 'package:memories_photos/settings.dart';

class SharedAlbumPage extends StatefulWidget {
  final FtpAlbum albumInfo;
  const SharedAlbumPage({super.key, required this.albumInfo});

  @override
  State<SharedAlbumPage> createState() => _SharedAlbumPageState();
}

class _SharedAlbumPageState extends State<SharedAlbumPage> {
  List<Photo> photos = [];
  bool isServerRunning = false;
  String ip = "";
  FtpServer? server;
  FTPConnect? client;

  void start() async {
    String ipp = (await widget.albumInfo.ip)!;
    setState(() {
      ip = ipp;
    });
  }

  @override
  void initState() {
    photos = PhotoIndexer.getPhotosIn(widget.albumInfo.folderPath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.widthOf(context);
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (screenWidth / Settings.gridScale).toInt()),
        itemCount: photos.length,
        itemBuilder: (context, index) => PhotoCard(i: index, photos: photos),
      ),
      primary: true,
      bottomSheet: Container(
        margin: .all(15),
        padding: .symmetric(horizontal: 12, vertical: 5),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          spacing: 10,
          children: [
            Text("${isServerRunning ? "🟢 Running on ftp://$ip:${widget.albumInfo.port}" : "🔴 Server is offline :("}"),
            ElevatedButton.icon(
              label: Text(isServerRunning ? "Stop" : "Start"),
              onPressed: () async {
                start();
                if (widget.albumInfo.client) {
                  client ??= FTPConnect(ip,
                    port: widget.albumInfo.port,
                    user: widget.albumInfo.name,
                    pass: widget.albumInfo.password
                  );
                } else {
                  server ??= FtpServer(
                    widget.albumInfo.port,
                    fileOperations: PhysicalFileOperations(widget.albumInfo.folderPath),
                    serverType: .readAndWrite,
                    username: widget.albumInfo.name,
                    password: widget.albumInfo.password
                  );

                  await toggleServerSafe();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> toggleServerSafe() async {
    if (!isServerRunning) {
      try {
        await server!.startInBackground();
      } on Exception catch (e) {
        print(e); //TODO
      } finally {
        setState(() {
          isServerRunning = true;
        });
      }
    } else {
       try {
        await server!.stop();
      } on Exception catch (e) {
        print(e); //TODO
      } finally {
        setState(() {
          isServerRunning = false;
        });
      }
    }
  }

}