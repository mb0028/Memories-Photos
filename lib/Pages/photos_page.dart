import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/blur.dart';
import 'package:memories_photos/Widgets/photo_card.dart';
import 'package:memories_photos/main.dart';
import 'package:memories_photos/Scripts/photo_indexer.dart';
import 'package:memories_photos/settings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:silky_scroll/silky_scroll.dart';

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
  ColorScheme appbarColorScheme = ColorScheme.fromSeed(seedColor: Settings.accent);

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

    if (Settings.adaptiveColors && widget.folder != null && photos!.isNotEmpty)
      appbarColorScheme = await ColorScheme.fromImageProvider(
        provider: FileImage(File(photos!.first.path)),
        dynamicSchemeVariant: .rainbow,
        brightness: MainAppState.brightness,
      );
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
    var padding = MediaQuery.paddingOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: widget.folder == null ? Colors.transparent : null,
      
      appBar: _appbar(context),
      
      body: photos != null && photos!.isNotEmpty ? Column(
        crossAxisAlignment: .stretch,
        children: [
          widget.folder != null ? SizedBox(
            height: padding.top + 60,
            child: Image.file(
              File(photos!.first.path),
              fit: .cover,
            )
          ) : SizedBox() ,
          Expanded(
            child: SilkyGridView.builder(
              scrollSpeed: 1.5,
              padding: .only(bottom: 200, top: widget.folder == null ? padding.top + 60 : 10,
                left: 5, right: 5),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (screenWidth / Settings.gridScale).toInt().clamp(1, 100)),
              itemCount: photos!.length,
              itemBuilder: (context, i) => PhotoCard(i: i, query: photos!),
            ),
          ),
        ],
      ) : Center(child: Text("Still loading or no photos 😵"))
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: BlurredContainerMonoP(
        roundneess: 50 * Settings.rm,
        padding: .symmetric(vertical: 10, horizontal: 20),
        color: appbarColorScheme.secondaryContainer.withAlpha(120),
        // border: .all(
        //   width: 2,
        //   color: appbarColorScheme.surface
        // ),
        child: Text(
          widget.folder != null
          ? widget.folder!.substring(widget.folder!.lastIndexOf(Platform.pathSeparator) + 1)
          : "All Photos",
          style: TextStyle(color: appbarColorScheme.onSecondaryContainer),
        )
      ),

      leading: widget.folder != null ? IconButton.filled(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(appbarColorScheme.primaryContainer)
        ),
        icon: Icon(
          Icons.arrow_back_rounded,
          color: appbarColorScheme.onPrimaryContainer
        ),
        tooltip: "Back",
        onPressed: () => Navigator.of(context).pop(),
      ) : null,

      actionsPadding: .only(right: 8),
      actions: [
        widget.folder != null && photos != null && photos!.isNotEmpty ? IconButton.filled(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(appbarColorScheme.secondaryContainer)
          ),
          icon: Icon(
            Icons.share,
            color: appbarColorScheme.onSecondaryContainer,
          ),
          tooltip: "Share album (limited to 50 recent images)",
          onPressed: () async {
            List<XFile> share = [];
            for (var i = 0; i < photos!.length.clamp(1, 50); i++)
              share.add(XFile(photos![i].path));

            var params = ShareParams(
              title: "Share Album",
              files: share,
            );
            await SharePlus.instance.share(params);
          }
        ) : SizedBox(),

        SizedBox(width: 10),

        IconButton.filled(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(appbarColorScheme.secondaryContainer)
          ),
          icon: Icon(
            Icons.grid_view_rounded,
            color: appbarColorScheme.onSecondaryContainer,
          ),
          tooltip: "Grid Settings",
          onPressed: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              builder: (context) => _GridScalePopup(onChanged: () => setState(() {}))
            );
          }
        ),
      ],
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
