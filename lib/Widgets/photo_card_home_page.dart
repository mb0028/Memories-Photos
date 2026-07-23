import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/photo_viewer_page.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/blur.dart';
import 'package:memories_photos/settings.dart';

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
              builder: (context) => PhotoViewerPage(query: query, i: i),
            )
          ),
          child: Container(
            clipBehavior: .antiAlias,
            decoration: BoxDecoration(
              borderRadius: .circular(20 * Settings.rm),
              color: Theme.of(context).colorScheme.secondaryContainer
            ),
            child: Hero(
              tag: query[i],
              child: Image.file(
                File(query[i].path),
                fit: .cover,
                width: 192,
                height: 192,
                cacheWidth: 192,
              ),
            ),
          ),
        ),
        
        GestureDetector(
          onTap: () => query[i].showMoreActionsPopup(context, evenMoreActions: true),
          child: BlurredContainerMonoP(
            margin: .all(5),
            padding: .all(5),
            width: 180,
            roundneess: 15 * Settings.rm,
            blur: 3.5,
            color: Theme.of(context).colorScheme.surfaceBright.withAlpha(120),
            child: Text(
              query[i].name,
              maxLines: 2,
              textAlign: .center,
              overflow: .fade,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface
              ),
            )
          ),
        )
      ],
    );
  }
}