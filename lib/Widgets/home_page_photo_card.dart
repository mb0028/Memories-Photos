import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/photo_viewer_page.dart';
import 'package:memories_photos/Structs/photo.dart';

class HomePagePhotoCard extends StatelessWidget {
  final Photo photo;
  const HomePagePhotoCard({super.key, required this.photo});
  final double size = 180;

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
            width: size,
            height: size,
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
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => photo.showMoreActionsPopup(evenMoreActions: true),
          child: Container(
            margin: .symmetric(vertical: 5),
            child: Text(
              photo.name,
              maxLines: 1,
              textAlign: .center,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSecondary
              ),
            ).frosted(
              borderRadius: .circular(15),
              padding: .all(6),
              width: size - 10,
              frostColor: Theme.of(context).colorScheme.secondary
            ),
          ),
        )
      ],
    );
  }
}