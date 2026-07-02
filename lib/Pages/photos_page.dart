import 'dart:io';
import 'package:blur/blur.dart';
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
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          widget.folder != null
          ? widget.folder!.substring(widget.folder!.lastIndexOf(Platform.pathSeparator) + 1)
          : "All Photos",
        ).frosted(
          blur: 5,
          borderRadius: .circular(50),
          padding: .symmetric(vertical: 10, horizontal: 20),
          frostColor: Theme.of(context).colorScheme.surfaceContainer
        ),
        leading: IconButton.filledTonal(
          icon: Icon(Icons.arrow_back_rounded),
          tooltip: "Back",
          onPressed: () => Navigator.of(context).pop(),
        ),
        actionsPadding: .only(right: 8),
        actions: [
          IconButton.filledTonal(
            icon: Icon(Icons.grid_view_rounded),
            tooltip: "Grid Settings",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                builder: (context) => _GridScalePopup(onChanged: () => setState(() {}))
              );
            }
          ),
        ],
      ),
      
      body: photos != null ? Column(
        crossAxisAlignment: .stretch,
        children: [
          widget.folder != null ? SizedBox(
            height: 90,
            child: Image.file(
              File(photos!.first.path),
              fit: .cover,
            )
          ) : SizedBox() ,
          Expanded(
            child: GridView.builder(
              padding: .only(bottom: 200, top: widget.folder == null ? 90 : 10),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (screenWidth / Settings.gridScale).toInt()),
              itemCount: photos!.length,
              itemBuilder: (context, i) => PhotoCard(i: i, query: photos!),
            ),
          ),
        ],
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}

class _GridScalePopup extends StatefulWidget {
  final Function onChanged;

  const _GridScalePopup({required this.onChanged});
  @override
  State<_GridScalePopup> createState() => _GridScalePopupState();
}

class _GridScalePopupState extends State<_GridScalePopup> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Slider(
        min: 40,
        max: 320,
        label: "Grid scale: ${Settings.gridScale - 20}%",
        showValueIndicator: .alwaysVisible,
        value: Settings.gridScale.toDouble(),
        onChanged: (value) {
          widget.onChanged();
          setState(() => Settings.gridScale = value.toInt());
          Settings.save();
        },
      ),
    );
  }
}
