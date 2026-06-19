import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/new_album_popup.dart';
import 'package:memories_photos/Popups/new_ftp_album_popup.dart';
import 'package:memories_photos/Widgets/album_card.dart';
import 'package:memories_photos/Widgets/title_text.dart';
import 'package:memories_photos/photo_indexer.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.widthOf(context);
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
                  onPressed: () async => await showNewAlbumDialog(context),
                  child: Text("New Album"),
                ),
              ),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () async => await showNewFtpAlbumDialog(context),
                  child: Text("New FTP Album"),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: .symmetric(horizontal: 15),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (screenWidth / 170).toInt()),
              itemCount: PhotoIndexer.albums.length,
              itemBuilder: (context, i) => AlbumCard(path: PhotoIndexer.albums[i]),
            ),
          ),
        )
      ],
    );
  }
}
