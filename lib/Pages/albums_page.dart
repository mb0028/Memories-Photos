import 'package:flutter/material.dart';
// import 'package:ftp_server/file_operations/physical_file_operations.dart';
// import 'package:ftp_server/ftp_server.dart';
// import 'package:ftp_server/server_type.dart';
import 'package:memories_photos/Popups/new_ftp_album_popup.dart';
import 'package:memories_photos/Widgets/title_text.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: 15,
      children: [
        TitleText(text: "Albums", color: Theme.of(context).colorScheme.secondary,),
        Padding(
          padding: .symmetric(horizontal: 15),
          child: Row(
            spacing: 15,
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  child: Text("New Album"),
                ),
              ),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () async => await showNewFtpAlbumeDialog(context),
                  child: Text("New FTP Album"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
