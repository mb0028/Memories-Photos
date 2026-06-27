import 'package:flutter/material.dart';
import 'package:memories_photos/Widgets/album_card.dart';
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
        SizedBox(
          height: 135,
          child: Center(
            child: Text(
              "Albums",
              style: TextStyle(
                fontFamily: Settings.CherryBombOne,
                fontSize: 36,
                color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
            ),
          ),
        ),
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
