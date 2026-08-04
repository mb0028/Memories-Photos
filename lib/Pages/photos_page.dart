import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories_photos/Scripts/media_store.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/photo_card.dart';
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
  Set<Photo>? photos;

  void load() async {
    if (widget.folder != null) {
      if (widget.folder == "[FAV]") {
        photos = {};
        for (var path in Settings.favorites)
          photos!.add(await Photo.fromPath(path));
      }
      else
        photos = await MbMediaStore.scanFolderFunky(widget.folder!);
    }
    else
      photos = MbMediaStore.photos;
    setState(() {});
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SystemUiOverlayStyle>(
      valueListenable: AlwaysStoppedAnimation(
        SystemUiOverlayStyle(
          statusBarIconBrightness: .dark,
          systemNavigationBarIconBrightness: .dark
        )
      ),
      builder: (context, value, child) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: widget.folder == null ? Colors.transparent : null,
        
        appBar: AppBar(
          backgroundColor: widget.folder != null ? Theme.of(context).colorScheme.surface.withAlpha(220) : Colors.transparent,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 45,
          title: Text(
            switch (widget.folder) {
              "[FAV]" => "Favorites",
              null => "All Photos",
              _ => widget.folder!.substring(widget.folder!.lastIndexOf(Platform.pathSeparator) + 1)
            },
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
      
          actionsPadding: .only(right: 8),
          actions: [
            widget.folder != null && photos != null && photos!.isNotEmpty ? IconButton(
              icon: Icon(Icons.share),
              tooltip: "Share album (limited to 50 recent images)",
              onPressed: () async {
                List<XFile> share = [];
                for (var i = 0; i < photos!.length.clamp(1, 50); i++)
                  share.add(XFile(photos!.elementAt(i).path));
      
                var params = ShareParams(
                  title: "Share Album",
                  files: share,
                );
                await SharePlus.instance.share(params);
              }
            ) : SizedBox(),
      
            SizedBox(width: 5),
      
            IconButton(
              icon: Icon(Icons.grid_view_rounded),
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
        ),
        
        body: photos != null ? SilkyGridView.builder(
          scrollSpeed: 1.5,
          padding: .only(bottom: 200, top: MediaQuery.paddingOf(context).top + 50,
            left: 2.5, right: 2.5),
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.widthOf(context) / Settings.gridScale).toInt().clamp(1, 100)),
          itemCount: photos!.length,
          itemBuilder: (context, i) => PhotoCard(i: i, query: photos!),
        ) : Center(child: Text("Still loading or no photos 😵"))
      )
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
