import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/photo_viewer_page.dart';
import 'package:memories_photos/Structs/photo.dart';

class HomePagePhotoCard extends StatelessWidget {
  final Photo photo;
  const HomePagePhotoCard({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.bottomCenter,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PhotoViewerPage(photo: photo),
            )
          ),
          child: Container(
            clipBehavior: .antiAlias,
            decoration: BoxDecoration(
              borderRadius: .circular(20),
              color: Theme.of(context).colorScheme.secondaryContainer
            ),
            child: Hero(
              tag: photo.path,
              child: Image.file(
                File(photo.path),
                fit: .cover,
                width: 190,
                height: 190,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => photo.showMoreActionsPopup(context ,evenMoreActions: true),
          child: Container(
            margin: .symmetric(vertical: 5),
            child: Text(
              photo.name,
              maxLines: 2,
              textAlign: .center,
              overflow: .fade,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onPrimary
              ),
            ).frosted(
              blur: 4,
              borderRadius: .circular(15),
              padding: .all(6),
              width: 180,
              frostColor: Theme.of(context).colorScheme.primaryContainer
            ),
          ),
        )
      ],
    );
  }
}