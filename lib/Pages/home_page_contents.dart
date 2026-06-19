import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memories_photos/Widgets/home_page_photo_card.dart';
import 'package:memories_photos/photo_indexer.dart';

class HomePageContents extends StatelessWidget {
  const HomePageContents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      viewportBuilder: (context, position) => Column(
        crossAxisAlignment: .stretch,
        children: [
          SizedBox(
            height: 220,
            child: Image.file(
              File(PhotoIndexer.ca[Random.secure().nextInt(PhotoIndexer.ca.length)].path),
              fit: .cover,
            ),
          ),
          Text(
            "Memories Photos",
            textAlign: .center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 28,
              fontWeight: .bold
            ),
          ),
          Container(
            margin: .all(15),
            height: 200,
            child: Row(
              children: [
                HomePagePhotoCard(photo: PhotoIndexer.ca[Random.secure().nextInt(PhotoIndexer.ca.length)],)
              ],
            ),
          )
        ],
      ),
    );
  }
}