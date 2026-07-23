import 'package:flutter/material.dart';
import 'package:memories_photos/Editor/editor_page.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:open_filex/open_filex.dart';

Future<bool> photosMoreActionPopup(BuildContext context, Photo photo, bool moreActions) async {
  bool needsRefresh = false;

  await showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      child: Container(
        width: 340,
        height: 360,
        padding: .all(15),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            moreActions ? ListTile(
              title: Text("View in"),
              leading: Icon(Icons.shortcut_outlined),
              onTap: () {
                needsRefresh = true;
                OpenFilex.open(photo.path);
                Navigator.of(context).pop();
              },
            ) : SizedBox(),
            moreActions ? ListTile(
              title: Text("Details"),
              leading: Icon(Icons.info_outline_rounded),
              onTap: () {
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
            moreActions ? ListTile(
              title: Text("Change Comment"),
              leading: Icon(Icons.insert_comment_outlined),
              onTap: () async {
                needsRefresh = true;
                await photo.showEditCommentPopup(context, () {});
                Navigator.of(context).pop();
              },
            ) : SizedBox(),
            ListTile(
              title: Text("Edit"),
              leading: Icon(Icons.edit_rounded),
              onTap: () {
                needsRefresh = true;
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditorPage(photo: photo)));
              },
            ),
            moreActions ? ListTile(
              title: Text(photo.isInFavorites ? "Remove from favorites" : "Add to favorites"),
              leading: Icon(photo.isInFavorites ? Icons.favorite_rounded : Icons.favorite_border_rounded),
              onTap: () {
                needsRefresh = true;
                photo.addToFavorites(context);
                Navigator.of(context).pop();
              },
            ) : SizedBox(),
            moreActions ? ListTile(
              title: Text("Delete"),
              leading: Icon(Icons.delete_outline_rounded),
              onTap: () async {
                needsRefresh = true;
                await photo.showDeletePopup(context, () {});
                Navigator.of(context).pop();
              },
            ) : SizedBox(),
            ListTile(
              title: Text("Share"),
              leading: Icon(Icons.share_rounded),
              onTap: () {
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
