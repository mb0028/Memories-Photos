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
                child: Image.file(
                  File(PhotoIndexer.getFolderThumb(path)!),
                  width: 256,
                  height: 256,
                  fit: .cover,
                ),
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
              "${PhotoIndexer.getFolderPhotosCount(path)} Photos",
              textAlign: .center,
              style: TextStyle(
                fontWeight: .w500,
                color: Theme.of(context).colorScheme.onSecondaryContainer
              ),
            )
          ],
        ),
      ),
    );
  }
}