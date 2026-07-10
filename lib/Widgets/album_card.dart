// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/photos_page.dart';
import 'package:memories_photos/Widgets/blur.dart';
import 'package:memories_photos/photo_indexer.dart';

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
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: .only(bottomLeft: .circular(10), bottomRight: .circular(25),
            topLeft: .circular(25), topRight: .circular(10))
        ),
        child: Stack(
          alignment: .bottomCenter,
          children: [

            Container(
              clipBehavior: .antiAlias,
              decoration: BoxDecoration(
                borderRadius: .only(bottomLeft: .circular(8), bottomRight: .circular(20),
                  topLeft: .circular(20), topRight: .circular(8))
              ),
              child: thumbnail != null ? Image.file(
                File(thumbnail),
                width: 256,
                height: 256,
                fit: .cover,
              ) : null,
            ),
            
            BlurredContainerMonoP(
              blur: 10,
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