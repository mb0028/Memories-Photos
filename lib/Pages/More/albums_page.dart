import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/More/trash_page.dart';
import 'package:memories_photos/Pages/photos_page.dart';
import 'package:memories_photos/Pages/settings_page.dart';
import 'package:memories_photos/Scripts/media_store.dart';
import 'package:memories_photos/settings.dart';
import 'package:silky_scroll/silky_scroll.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.widthOf(context);

    return Stack(
      alignment: .bottomCenter,
      children: [
        SilkyGridView.builder(
          scrollSpeed: 1.5,
          padding: .only(bottom: 250, top: MediaQuery.paddingOf(context).top + 5),
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (screenWidth / Settings.gridScale / 1.5).toInt().clamp(1, 100),
            childAspectRatio: 0.75
          ),
          itemCount: MbMediaStore.albums.length,
          itemBuilder: (context, i) => AlbumCard(path: MbMediaStore.albums.keys.elementAt(i))
        ),

        Padding(
          padding: .only(bottom: MediaQuery.paddingOf(context).bottom + 80, left: 5),
          child: Row(
            spacing: 5,
            children: [
              FilledButton.tonalIcon(
                icon: Icon(Icons.recycling_rounded),
                label: Text("Trash"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrashPage())),
              ),
              FilledButton.tonalIcon(
                icon: Icon(Icons.favorite_rounded),
                label: Text("Favorites"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhotosPage(folder: "[FAV]"))),
              ),
              IconButton.filledTonal(
                icon: Icon(Icons.settings_rounded),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage())),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class AlbumCard extends StatelessWidget {
  final String path;
  const AlbumCard({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    String? thumbnail = MbMediaStore.albums[path]?.thumbnail;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhotosPage(folder: path))),
      child: Container(
        padding: .all(5),
        margin: .all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(200),
          borderRadius: .only(bottomLeft: .circular(10 * Settings.rm), bottomRight: .circular(25 * Settings.rm),
            topLeft: .circular(25 * Settings.rm), topRight: .circular(10 * Settings.rm))
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                clipBehavior: .antiAlias,
                decoration: BoxDecoration(
                  borderRadius: .only(bottomLeft: .circular(8 * Settings.rm), bottomRight: .circular(20 * Settings.rm),
                    topLeft: .circular(20 * Settings.rm), topRight: .circular(8 * Settings.rm))
                ),
                child: thumbnail != null ? Image.file(
                  File(thumbnail),
                  width: 512,
                  height: 512,
                  fit: .cover,
                ) : null,
              ),
            ),
            SizedBox(
              height: 60,
              child: Text(
                "${path.substring(path.lastIndexOf(Platform.pathSeparator) + 1)}\n${MbMediaStore.albums[path]?.itemsInIt} Photos",
                textAlign: .center,
                maxLines: 3,
                overflow: .ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiaryContainer
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
