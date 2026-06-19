import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/photo_indexer.dart';
import 'package:memories_photos/Pages/photo_viewer_page.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({
    super.key,
  });

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {

  @override
  void initState() {
    PhotoIndexer.startCa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.widthOf(context);
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (screenWidth / 120) .toInt()),
      itemCount: PhotoIndexer.ca.length,
      itemBuilder: (context, i) => _PhotosPagePhotoCard(i: i),
    );
  }
}

class _PhotosPagePhotoCard extends StatelessWidget {
  final int i;
  const _PhotosPagePhotoCard({required this.i});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewerPage(photo: PhotoIndexer.ca[i]),
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
          tag: PhotoIndexer.ca[i],
          child: Image.file(
            File(PhotoIndexer.ca[i].path),
            // cacheHeight: 256,
            // cacheWidth: 256,
            fit: .cover,
          ),
        ),
      ),
    );
  }
}