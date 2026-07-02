import 'package:flutter/material.dart';
import 'package:memories_photos/Editor/collage_maker_page.dart';
import 'package:memories_photos/Editor/editor_page.dart';
import 'package:memories_photos/Popups/new_album_popup.dart';
import 'package:memories_photos/image_helper.dart';
import 'package:memories_photos/settings.dart';

Future<bool> showHomeCreateNewPopup(BuildContext context) async {
  bool returnTrue = false;
  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(240),
    builder: (context) => Container(
      margin: .symmetric(horizontal: 15),
      width: 420,
      height: 360,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: .spaceEvenly,
            spacing: 15,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  label: Text(
                    "Record Video",
                    style: TextStyle(
                      fontFamily: Settings.ElmsSans
                    ),
                  ),
                  icon: Icon(Icons.video_camera_front_outlined),
                  onPressed: () {
                    // TODO: recording video
                    returnTrue = true;
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Expanded(
                child: FilledButton.icon(
                  label: Text(
                    "Capture Photo",
                    style: TextStyle(
                      fontFamily: Settings.ElmsSans
                    ),
                  ),
                  icon: Icon(Icons.add_a_photo_rounded),
                  onPressed: () async {
                    await ImageHelper.takePicture();
                    returnTrue = true;
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "🌲 Create New ✨",
            textAlign: .center,
            style: TextStyle(
              fontSize: 24,
              fontFamily: Settings.CherryBombOne
            ),
          ),
          ListTile(
            title: Text("Album"),
            leading: Icon(Icons.photo_album_outlined),
            onTap: () async {
              await showNewAlbumDialog(context);
              returnTrue = true;
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text("Collage"),
            leading: Icon(Icons.collections_outlined),
            onTap: () {
              returnTrue = true;
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CollageMakerPage(),));
            },
          ),
          ListTile(
            title: Text("Edit then save as"),
            leading: Icon(Icons.image_outlined),
            onTap: () {
              returnTrue = true;
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditorPage(),));
            },
          ),
          ListTile(
            title: Text("GIF"),
            leading: Icon(Icons.gif_rounded),
            onTap: () {
              // TODO: create gif using png comparer 28
              returnTrue = true;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    )
  );
  return returnTrue;
}