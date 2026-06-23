import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/photo_card.dart';
import 'package:memories_photos/photo_indexer.dart';
import 'package:memories_photos/settings.dart';

class PhotosPage extends StatefulWidget {
  final String? folder;
  const PhotosPage({
    super.key, this.folder,
  });

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  List<Photo>? photos;

  void load() async {
    if (widget.folder != null)
      photos = await PhotoIndexer.getFolderPhotos(widget.folder!);
    else
      photos = PhotoIndexer.photos;
    setState(() {});
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.widthOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(220),
        title: Text(
          widget.folder != null
          ? widget.folder!.substring(widget.folder!.lastIndexOf(Platform.pathSeparator) + 1)
          : "All Photos"
        ),
      ),
      body: photos != null ? GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (screenWidth / Settings.gridScale).toInt()),
        itemCount: photos!.length,
        itemBuilder: (context, i) => PhotoCard(i: i, query: photos!),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
