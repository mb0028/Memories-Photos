import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Scripts/photo_indexer.dart';
import 'package:memories_photos/settings.dart';
import 'package:silky_scroll/silky_scroll.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trash"),
        actionsPadding: .only(right: 8),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever_outlined),
            tooltip: "Clear Trash",
            onPressed: () {
              showStyledToast("Coming Soon", context);
            },
          )
        ],
      ),
      body: Container(
        margin: .all(10),
        child: PhotoIndexer.photosInTrash.isNotEmpty ? SilkyGridView.builder(
          scrollSpeed: 1.5,
          padding: .only(bottom: 200),
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.widthOf(context) / (Settings.gridScale * 1.3)).toInt().clamp(1, 100)),
          itemCount: PhotoIndexer.photosInTrash.length,
          itemBuilder: (context, i) => GestureDetector(
            onTap: () async {
              await showDialog(context: context, builder: (context) => Dialog(
                child: Container(
                  padding: .all(15),
                  width: 300,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: .spaceEvenly,
                    children: [
                      ListTile(
                        leading: Icon(Icons.delete_forever_rounded),
                        title: Text("Delete Forever"),
                        onTap: () async {
                          await File(PhotoIndexer.photosInTrash[i].path).delete();
                          setState(() => PhotoIndexer.photosInTrash.removeAt(i));
                          showStyledToast("Deleted!", context);
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.restore_rounded),
                        title: Text("Restore"),
                        onTap: () async {
                          await PhotoIndexer.photosInTrash[i].restoreFromTrash();
                          setState(() => PhotoIndexer.photosInTrash.removeAt(i));
                          showStyledToast("Restored!", context);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ));
            },
            child: Container(
              clipBehavior: .antiAlias,
              margin: .all(2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(200),
                borderRadius: .circular(25 * Settings.rm),
              ),
              child: Hero(
                tag: PhotoIndexer.photosInTrash[i],
                child: Image.file(
                  File(PhotoIndexer.photosInTrash[i].path),
                  cacheWidth: 320,
                  fit: .cover,
                ),
              ),
            ),
          ),
        ) : Center(child: Text("Trash is empty")),
      ),
    );
  }
}