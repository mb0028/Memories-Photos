import 'package:flutter/material.dart';
import 'package:memories_photos/Editor/editor_page.dart';
import 'package:memories_photos/Structs/photo.dart';

Future<bool> photosMoreActionPopup(BuildContext context, Photo photo) async {
  bool needsRefresh = false;

  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    builder: (context) => SizedBox(
      width: 300,
      height: 300,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ListTile(
            title: Text("Edit"),
            leading: Icon(Icons.edit_rounded),
            onTap: () {
              needsRefresh = true;
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditorPage(photo: photo)));
            },
          ),
          ListTile(
            title: Text("Share"),
            leading: Icon(Icons.share_rounded),
            onTap: () {
              needsRefresh = true;
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    ),
  );

  return needsRefresh;
}
