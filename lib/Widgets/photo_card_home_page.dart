import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/photo_viewer_page.dart';
import 'package:memories_photos/Structs/photo.dart';

class PhotoCardHomePage extends StatelessWidget {
  final List<Photo> query;
  final int i;
  const PhotoCardHomePage({super.key, required this.query, required this.i});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.bottomCenter,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PhotoViewerPage(query: query, i: i,),
            )
          ),
          child: Container(
            clipBehavior: .antiAlias,
            decoration: BoxDecoration(
              borderRadius: .circular(20),
              color: Theme.of(context).colorScheme.secondaryContainer
            ),
            child: Hero(
              tag: query[i].path,
              child: Image.file(
                File(query[i].path),
                fit: .cover,
                width: 190,
                height: 190,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => query[i].showMoreActionsPopup(context, evenMoreActions: true),
          child: Container(
            margin: .symmetric(vertical: 5),
            child: Text(
              query[i].name,
              maxLines: 2,
              textAlign: .center,
              overflow: .fade,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface
              ),
            ).frosted(
              blur: 4,
              borderRadius: .circular(15),
              padding: .all(6),
              width: 180,
              frostColor: Theme.of(context).colorScheme.surface
            ),
          ),
        )
      ],
    );
  }
}