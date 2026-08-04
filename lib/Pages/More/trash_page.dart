import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Scripts/media_store.dart';
import 'package:memories_photos/Widgets/expressive_button.dart';
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
        child: MbMediaStore.photosInTrash.isNotEmpty ? SilkyGridView.builder(
          scrollSpeed: 1.5,
          padding: .only(bottom: 200),
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.widthOf(context) / (Settings.gridScale * 1.3)).toInt().clamp(1, 100)),
          itemCount: MbMediaStore.photosInTrash.length,
          itemBuilder: (context, i) => GestureDetector(
            onTap: () async {
              await showDialog(context: context, builder: (context) => Dialog(
                child: Container(
                  padding: .symmetric(vertical: 15),
                  width: 300,
                  height: 198,
                  child: Column(
                    mainAxisAlignment: .spaceEvenly,
                    children: [
                      ExpressiveButton.top(
                        icon: Icon(Icons.delete_forever_rounded),
                        text: "Delete Forever",
                        onClick: () async {
                          await File(MbMediaStore.photosInTrash.elementAt(i).path).delete();
                          setState(() => MbMediaStore.photosInTrash.remove(MbMediaStore.photosInTrash.elementAt(i)));
                          showStyledToast("Deleted!", context);
                          Navigator.of(context).pop();
                        },
                      ),
                      ExpressiveButton.end(
                        icon: Icon(Icons.restore_rounded),
                        text: "Restore",
                        onClick: () async {
                          await MbMediaStore.photosInTrash.elementAt(i).restoreFromTrash();
                          setState(() => MbMediaStore.photosInTrash.remove(MbMediaStore.photosInTrash.elementAt(i)));
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
                tag: MbMediaStore.photosInTrash.elementAt(i),
                child: Image.file(
                  File(MbMediaStore.photosInTrash.elementAt(i).path),
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