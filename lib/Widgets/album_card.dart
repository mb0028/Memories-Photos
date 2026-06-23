// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/photos_page.dart';
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
        padding: .all(4),
        margin: .all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: .circular(25)
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                clipBehavior: .antiAlias,
                decoration: BoxDecoration(
                  borderRadius: .circular(20)
                ),
                child: thumbnail != null ? Image.file(
                  File(thumbnail),
                  width: 256,
                  height: 256,
                  fit: .cover,
                ) : null,
              ),
            ),
            Text(
              path.substring(path.lastIndexOf(Platform.pathSeparator) + 1),
              textAlign: .center,
              maxLines: 1,
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
      ),
    );
  }
}