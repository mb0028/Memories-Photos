// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/photos_page.dart';
import 'package:memories_photos/Widgets/blur.dart';
import 'package:memories_photos/photo_indexer.dart';
import 'package:memories_photos/settings.dart';

class AlbumCard extends StatelessWidget {
  final String path;
  
  const AlbumCard({
    super.key, required this.path,
  });

  @override
  Widget build(BuildContext context) {
    String? thumbnail = PhotoIndexer.albums[path]?.thumbnail;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotosPage(folder: path),
        )
      ),
      child: Container(
        padding: .all(5),
        margin: .all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(200),
          borderRadius: .only(bottomLeft: .circular(10 * Settings.rm), bottomRight: .circular(25 * Settings.rm),
            topLeft: .circular(25 * Settings.rm), topRight: .circular(10 * Settings.rm))
        ),
        child: Stack(
          alignment: .bottomCenter,
          children: [
            Container(
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
            
            BlurredContainerMonoP(
              blur: 6,
              height: 60,
              width: 400,
              margin: .all(5),
              padding: .symmetric(horizontal: 5, vertical: 2.5),
              color: Theme.of(context).colorScheme.surface.withAlpha(80),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    path.substring(path.lastIndexOf(Platform.pathSeparator) + 1),
                    textAlign: .center,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: TextStyle(
                      fontWeight: .w500,
                      color: Theme.of(context).colorScheme.onSecondaryContainer
                    ),
                  ),
                  Text(
                    "${PhotoIndexer.albums[path]?.itemsInIt} Photos",
                    textAlign: .center,
                    style: TextStyle(
                      fontWeight: .w500,
                      fontSize: 10.5,
                      color: Theme.of(context).colorScheme.onSecondaryContainer
                    ),
                  ),
                ],
              ),
            )
            
          ],
        ),
      ),
    );
  }
}