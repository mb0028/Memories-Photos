import 'package:flutter/material.dart';
import 'package:memories_photos/Widgets/album_card.dart';
import 'package:memories_photos/Widgets/title_text.dart';
import 'package:memories_photos/photo_indexer.dart';
import 'package:memories_photos/settings.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.widthOf(context);

    return Column(
      crossAxisAlignment: .stretch,
      spacing: 5,
      children: [
        TitleText(text: "Albums", color: Theme.of(context).colorScheme.secondary,),
        
        Expanded(
          child: Padding(
            padding: .symmetric(horizontal: 15),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (screenWidth / Settings.gridScale / 1.5).toInt()),
              itemCount: PhotoIndexer.albums.length,
              itemBuilder: (context, i) => AlbumCard(path: PhotoIndexer.albums.keys.elementAt(i))
            ),
          ),
        )
      ],
    );
  }
}
