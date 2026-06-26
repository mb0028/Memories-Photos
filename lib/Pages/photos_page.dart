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
    if (widget.folder != null) {
      if (widget.folder == "[FAV]") {
        photos = [];
        for (var path in Settings.favorites)
          photos!.add(await Photo.fromPath(path));
      }
      else
        photos = await PhotoIndexer.getFolderPhotos(widget.folder!);
    }
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
        actionsPadding: .only(right: 8),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view_rounded),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) => SizedBox(
                  height: 140,
                  child: Slider(
                    min: 40,
                    max: 320,
                    label: "Grid scale",
                    showValueIndicator: .alwaysVisible,
                    value: Settings.gridScale.toDouble(),
                    onChanged: (value) {
                      setState(() => Settings.gridScale = value.toInt());
                      Settings.save();
                    },
                  ),
                )
              );
            }
          ),
        ],
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
