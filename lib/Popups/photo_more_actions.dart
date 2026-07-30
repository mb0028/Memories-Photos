import 'package:flutter/material.dart';
import 'package:memories_photos/Editor/editor_page.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/expressive_button.dart';
import 'package:open_filex/open_filex.dart';

Future<bool> photosMoreActionPopup(BuildContext context, Photo photo, bool moreActions) async {
  bool needsRefresh = false;

  await showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      insetPadding: .all(5),
      child: Container(
        width: 380,
        height: moreActions ? 612 : 280,
        padding: .symmetric(vertical: 15),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            ExpressiveButton.top(
              text: "View in",
              icon: Icon(Icons.shortcut_outlined),
              onClick: () {
                needsRefresh = true;
                OpenFilex.open(photo.path);
                Navigator.of(context).pop();
              },
            ),
            moreActions ? ExpressiveButton(
              text: "Change Comment",
              icon: Icon(Icons.insert_comment_outlined),
              onClick: () async {
                needsRefresh = true;
                await photo.showEditCommentPopup(context, () {});
                Navigator.of(context).pop();
              },
            ) : SizedBox(),
            moreActions ? ExpressiveButton(
              text: "Details",
              icon: Icon(Icons.park_outlined),
              onClick: () {
                needsRefresh = true;
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Dialog.fullscreen(
                  child: FutureBuilder(
                    future: photo.getDetailsWidget(context),
                    builder: (context, snapshot) => snapshot.data ?? SizedBox(),
                  ),
                )));
              },
            ) : SizedBox(),
            moreActions ? ExpressiveButton(
              text: photo.isInFavorites ? "Remove from favorites" : "Add to favorites",
              icon: Icon(photo.isInFavorites ? Icons.favorite_rounded : Icons.favorite_border_rounded),
              onClick: () {
                needsRefresh = true;
                photo.addToFavorites(context);
                Navigator.of(context).pop();
              },
            ) : SizedBox(),
            moreActions ? ExpressiveButton(
              text: "Delete",
              icon: Icon(Icons.delete_outline_rounded),
              onClick: () async {
                needsRefresh = true;
                await photo.showDeletePopup(context, () {});
                Navigator.of(context).pop();
              },
            ) : SizedBox(),
            ExpressiveButton(
              text: "Edit",
              icon: Icon(Icons.draw_rounded),
              onClick: () {
                needsRefresh = true;
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditorPage(photo: photo)));
              },
            ),
            ExpressiveButton.end(
              text: "Share",
              icon: Icon(Icons.share_rounded),
              onClick: () {
                photo.share();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    ),
  );

  return needsRefresh;
}
