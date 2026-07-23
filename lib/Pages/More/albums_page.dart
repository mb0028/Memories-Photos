import 'package:flutter/material.dart';
import 'package:memories_photos/Widgets/album_card.dart';
import 'package:memories_photos/Scripts/photo_indexer.dart';
import 'package:memories_photos/settings.dart';
import 'package:silky_scroll/silky_scroll.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.widthOf(context);

    return Padding(
      padding: .symmetric(horizontal: 5),
      child: SilkyGridView.builder(
        scrollSpeed: 1.5,
        padding: .only(bottom: 250, top: MediaQuery.paddingOf(context).top + 5),
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (screenWidth / Settings.gridScale / 1.5).toInt().clamp(1, 100),
          childAspectRatio: 0.75
        ),
        itemCount: PhotoIndexer.albums.length,
        itemBuilder: (context, i) => AlbumCard(path: PhotoIndexer.albums.keys.elementAt(i))
      ),
    );
  }
}
