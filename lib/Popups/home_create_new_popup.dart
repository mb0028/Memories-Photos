import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/More/camera_timelapse_page.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Scripts/image_helper.dart';
import 'package:memories_photos/Widgets/expressive_button.dart';
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
                    "Timelapse",
                    style: TextStyle(
                      fontFamily: Settings.ElmsSans
                    ),
                  ),
                  icon: Icon(Icons.timelapse_outlined),
                  onPressed: () async {
                    returnTrue = true;
                    Navigator.of(context).pop();
                    if (Platform.isWindows) // TODO: Implement Camera & Timelapse for windows
                      showStyledToast("Coming Soon!", context);
                    else Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraTakeTimelapsePage()));
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
                    returnTrue = true;
                    Navigator.of(context).pop();
                    if (Platform.isWindows)
                      showStyledToast("Coming Soon!", context);
                     else await ImageHelper.takePicture(context);
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
          ExpressiveButton.top(
            text: "Collage",
            icon: Icon(Icons.collections_outlined),
            onClick: () {
              showStyledToast("Coming Soon!", context); //TODO: collage
              returnTrue = true;
              Navigator.of(context).pop();
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => CollageMakerPage(),));
            },
          ),
          ExpressiveButton.end(
            text: "GIF",
            icon: Icon(Icons.gif_rounded),
            onClick: () {
              showStyledToast("Coming Soon!", context); // TODO: Gif
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