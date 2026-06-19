import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/photo_indexer.dart';
import 'package:memories_photos/Pages/photo_viewer_page.dart';

class PhotosPage extends StatefulWidget {
  final String? folder;
  const PhotosPage({
    super.key, this.folder,
  });

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  late List<Photo> photos;

  @override
  void initState() {
    //PhotoIndexer.startCa();

    if(widget.folder != null) {
      photos = PhotoIndexer.getPhotosIn(widget.folder!);
    } else {
      photos = PhotoIndexer.photos;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.widthOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.folder != null
          ? widget.folder!.substring(widget.folder!.lastIndexOf(Platform.pathSeparator) + 1)
          : "All Photos"
        ),
      ),
      body: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (screenWidth / 120) .toInt()),
        itemCount: photos.length,
        itemBuilder: (context, i) => _PhotosPagePhotoCard(i: i, photos: photos),
      ),
    );
  }
}


class _PhotosPagePhotoCard extends StatelessWidget {
  final int i;
  final List<Photo> photos;
  const _PhotosPagePhotoCard({required this.i, required this.photos});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewerPage(photo: photos[i]),
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
          tag: photos[i].path,
          child: Image.file(
            File(photos[i].path),
            // cacheHeight: 256,
            // cacheWidth: 256,
            fit: .cover,
          ),
        ),
      ),
    );
  }
}