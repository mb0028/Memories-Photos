import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/new_album_popup.dart';
import 'package:memories_photos/image_helper.dart';

Future<bool> showHomeCreateNewPopup(BuildContext context) async {
  bool returnTrue = false;
  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(240),
    builder: (context) => Container(
      margin: .symmetric(horizontal: 15),
      width: 360,
      height: 360,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: .spaceEvenly,
            spacing: 15,
            children: [
              OutlinedButton.icon(
                label: Text("Record Video"),
                icon: Icon(Icons.video_camera_front_outlined),
                onPressed: () {
                  // TODO: recording video
                  returnTrue = true;
                  Navigator.of(context).pop();
                },
              ),
              FilledButton.icon(
                label: Text("Capture Photo"),
                icon: Icon(Icons.add_a_photo_rounded),
                onPressed: () async {
                  await ImageHelper.takePicture();
                  returnTrue = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          SizedBox(height: 15,),
          Text(
            "🌲 Create New ✨",
            textAlign: .center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: .bold
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
              // TODO: create Collage using png comparer 28
              returnTrue = true;
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text("Png"),
            leading: Icon(Icons.image_outlined),
            onTap: () {
              // TODO: create png using png comparer 28
              returnTrue = true;
              Navigator.of(context).pop();
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