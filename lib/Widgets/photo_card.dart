import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/photo_viewer_page.dart';
import 'package:memories_photos/Structs/photo.dart';

class PhotoCard extends StatelessWidget {
  final List<Photo> query;
  final int i;
  const PhotoCard({super.key, required this.i, required this.query});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewerPage(query: query, i: i),
        )
      ),
      child: Container(
        clipBehavior: .antiAlias,
        margin: .all(2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: .all(.circular(25)),
        ),
        child: Hero(
          tag: query[i].path,
          child: Image.file(
            File(query[i].path),
            cacheHeight: 180,
            cacheWidth: 180,
            fit: .cover,
          ),
        ),
      ),
    );
  }
}