// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ftp_server/file_operations/physical_file_operations.dart';
import 'package:ftp_server/ftp_server.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Structs/ftp_album.dart';
import 'package:memories_photos/Widgets/monop_text_field.dart';
import 'package:memories_photos/settings.dart';

class SharedAlbumPage extends StatefulWidget {
  final FtpAlbum albumInfo;
  const SharedAlbumPage({super.key, required this.albumInfo});

  @override
  State<SharedAlbumPage> createState() => _SharedAlbumPageState();
}

class _SharedAlbumPageState extends State<SharedAlbumPage> {
  bool isServerRunning = false;
  bool isClientRunning = false;
  String ip = "";
  FtpServer? server;
  FTPConnect? client;
  bool connecting = false;
  String connectingText = "☀️ Connecting...";
  var clientIpToConnect = TextEditingController();
  double? downloadProgress = 0;

  void initClientIP() async {
    String? ipp = await widget.albumInfo.ip;
    ip = ipp ?? "";
    if (ip.length > 4)
      setState(() {
        clientIpToConnect.text = ip.substring(0, ip.lastIndexOf('.') + 1);
      });
    else
      showStyledToast("Connect to Wifi or turn Hotspot on to start the server", context, duration: 4);
  }

  @override
  void initState() {
    if (widget.albumInfo.client)
      initClientIP();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.widthOf(context);
    return Scaffold(
      appBar: AppBar(), 
      body: PopScope(
        canPop: !isServerRunning,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop)
            showStyledToast("Stop server before exit! ", context, duration: 3);
        },
        child: RefreshIndicator(
          onRefresh: () async {
            widget.albumInfo.client ? await refreshPhotos() : setState(() {
            });
          },
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (screenWidth / Settings.gridScale).toInt()),
            itemCount: widget.albumInfo.photos.length,
            itemBuilder: (context, index) => Image.network(""),
          ),
        ),
      ),
      primary: true,
      bottomSheet: Container(
        height: (widget.albumInfo.client ? 150 : 108) + 45,
        margin: .all(10).add(.only(bottom: 40)), // TODO: adaptive nav bar padding
        padding: .symmetric(horizontal: 12, vertical: 5),
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: 5,
          children: [
            OutlinedButton(
              child: Text("Add to album"),
              onPressed: () {
                
              },
            ),
            Expanded(child: widget.albumInfo.client ? clientUI() : serverUI()),
            Text(widget.albumInfo.client
              ? isClientRunning ? "🌲 Connected: ftp://$ip:${widget.albumInfo.port}" : (connecting ? connectingText : "❌ Not connected")
              : isServerRunning ? "🌲 Running! user: ${widget.albumInfo.name} | pass: ${widget.albumInfo.password}\nftp://$ip:${widget.albumInfo.port}" : "🔴 Server is offline :("
            ),
          ],
        ),
      ),
    );
  }

  Widget serverUI() {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: 5,
      children: [
        FilledButton.icon(
          label: Text(isServerRunning ? "Stop" : "Start"),
          icon: Icon(isServerRunning ? Icons.stop_rounded : Icons.language_outlined),
          onPressed: () async {
            String? ipp = await widget.albumInfo.ip;
            setState(() => ip = ipp ?? "");
            if (ip.isEmpty) {
              showStyledToast("Connect to Wifi or turn Hotspot on to start the server", context, duration: 4);
              return;
            }
            server ??= FtpServer(
              widget.albumInfo.port,
              fileOperations: PhysicalFileOperations(widget.albumInfo.folderPath),
              serverType: .readAndWrite,
              username: widget.albumInfo.name,
              password: widget.albumInfo.password
            );
    
            await toggleServerSafe(context);
          }
        ),
      ],
    );
  }

  Widget clientUI() {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: 5,
      children: [
        LinearProgressIndicator(
          value: downloadProgress,
          minHeight: 10,
          borderRadius: .circular(10),
        ),
        !connecting && !isClientRunning ? Text("Complate IP address before connecting.") : SizedBox(),
        Expanded(
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: MonoPTextField(controller: clientIpToConnect)
              ),
              Expanded(
                flex: 0,
                child: Container(
                  margin: .all(5),
                  child: !connecting ? OutlinedButton(
                    onPressed: () =>  clientConnect(context),
                    child: Text("Connect"),
                  ) : SizedBox(),
                ),
              ),
            ],
          ),
        )
      ]
    );
  }


  Future<void> clientConnect(BuildContext context) async {
    if (isClientRunning)
      return;
    try {
      setState(() {
        connecting = true;
        downloadProgress = null;
      });
      
      if (clientIpToConnect.text.isEmpty) {
        showStyledToast("Connect to Wifi or turn Hotspot", context, duration: 4);
        return;
      }

      client ??= FTPConnect(clientIpToConnect.text,
        port: widget.albumInfo.port,
        user: widget.albumInfo.name,
        pass: widget.albumInfo.password,
        timeout: 30,
        securityType: .ftp
      );
      var run = await client!.connect();

      if (!run)
        showStyledToast("Failed to connect", context, duration: 3);

      await refreshPhotos();
        
      setState(() => isClientRunning = true);
    } on Exception catch (e) {
      showStyledToast(e.toString(), context, duration: 7);
      if (isClientRunning)
        await client!.disconnect();
      setState(() => isClientRunning = false);
    } finally {
      setState(() {
        connecting = false;
        downloadProgress = 1;
      });
    }
  }

  Future<void> toggleServerSafe(BuildContext context) async {
    if (!isServerRunning) {
      try {
        await server!.startInBackground();
      } on Exception catch (e) {
        showStyledToast(e.toString(), context, duration: 7);
        await server!.stop();
      } finally {
        setState(() {
          isServerRunning = true;
        });
      }
    } else {
       try {
        await server!.stop();
      } on Exception catch (e) {
        showStyledToast(e.toString(), context, duration: 7);
      } finally {
        setState(() {
          isServerRunning = false;
        });
      }
    }
  }

  Future<void> refreshPhotos() async {
    try {
      if (client == null) return;

      // List<FTPEntry> rFiles = await client!.listDirectoryContent();
      // List<String> alreadySyncedFiles = [];
      // List<String> serverFiles = [];
      
      // Pass 0 : Get client and server file paths
      // for (var file0 in Directory(widget.albumInfo.folderPath).listSync()) {
      //   String path = file0.path;
      //   if (path.contains(".png") || path.contains(".jpg") || path.contains(".jpeg"))
      //     alreadySyncedFiles.add(path);
      // }
      // for (var file00 in rFiles) {
      //   String path = file00.name;
      //   if (path.contains(".png") || path.contains(".jpg") || path.contains(".jpeg"))
      //     serverFiles.add(path);
      // }
    
      setState(() {});
    } on Exception catch (e) {
      showStyledToast(e.toString(), context);
    }
    
  }

}