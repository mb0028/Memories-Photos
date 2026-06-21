import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/add_ftp_album_popup.dart';
import 'package:memories_photos/Popups/new_album_popup.dart';
import 'package:memories_photos/Popups/new_ftp_album_popup.dart';
import 'package:memories_photos/Structs/ftp_album.dart';
import 'package:memories_photos/Widgets/album_card.dart';
import 'package:memories_photos/Widgets/title_text.dart';
import 'package:memories_photos/photo_indexer.dart';
import 'package:memories_photos/settings.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.widthOf(context);
    List<Object> albums = [];

    for (var f in PhotoIndexer.ftpAlbums)
      albums.add(f as Object);
    for (var f in PhotoIndexer.albums)
      albums.add(f as Object);
    

    return Column(
      crossAxisAlignment: .stretch,
      spacing: 5,
      children: [
        TitleText(text: "Albums", color: Theme.of(context).colorScheme.secondary,),
        
        Padding(
          padding: .symmetric(horizontal: 15),
          child: Row(
            spacing: 15,
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () async => await addNewFtpAlbumDialog(context),
                  child: Text("Add FTP album"),
                ),
              ),
              Expanded(
                child: FilledButton(
                  onPressed: () async => await showNewFtpAlbumDialog(context),
                  child: Text("New FTP album"),
                ),
              ),
            ],
          ),
        ),
        
        Padding(
          padding: .symmetric(horizontal: 15),
          child: FilledButton.tonal(
            onPressed: () async => await showNewAlbumDialog(context),
            child: Text("New album"),
          ),
        ),
        
        Expanded(
          child: Padding(
            padding: .symmetric(horizontal: 15),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (screenWidth / Settings.gridScale / 1.5).toInt()),
              itemCount: PhotoIndexer.albums.length,
              itemBuilder: (context, i) => albums[i] is String
                ? AlbumCard(path: albums[i] as String, isFtp: false)
                : AlbumCard(path: (albums[i] as FtpAlbum).folderPath, isFtp: true, ftpInfo: albums[i] as FtpAlbum,),
            ),
          ),
        )
      ],
    );
  }
}
