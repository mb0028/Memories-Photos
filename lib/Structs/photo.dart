import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memories_photos/ExifInterface/exif_interface.dart';
import 'package:memories_photos/ExifInterface/tags.dart';
import 'package:memories_photos/Popups/monop_dialog.dart';
import 'package:memories_photos/Popups/photo_more_actions.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Widgets/monop_text_field.dart';
import 'package:memories_photos/Widgets/photo_details.dart';
import 'package:memories_photos/settings.dart';

/// Holds path to the photo and helpful methods. <br/>
/// F**k dart with this lowercase naming rule
class Photo {
  Photo({required this.path});

  static Future<Photo> fromPath(String path) async {
    var p = Photo(path: path);
    String ds = await ExifInterface.getAttribute(path, ExifTag.TAG_DATETIME_ORIGINAL);
    if (ds.isNotEmpty) {
      DateTime? d = DateTime.tryParse(ds.replaceAll(":", "").replaceAll(" ", "T"));
      if (d != null) p.dateTaken = d;
    }
    else p.dateTaken = await File(path).lastModified();
    return p;
  }

  // Fields
  final String path;
  DateTime dateTaken = DateTime(0); // Its used a lot so better storing it in memeory
  
  String get name => path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
  
  Future<String> get commentOrName async {
    String comment = await ExifInterface.getAttribute(path, ExifTag.TAG_USER_COMMENT);
    if (comment.isNotEmpty)
      return comment;
    return name;
  }

  /// Returns: true if 5..9 AM
  bool get isTakenAtMorning => dateTaken.hour > 5 && dateTaken.hour < 10;
  /// Returns: true if 7..10 PM
  bool get isTakenAtEvening => dateTaken.hour > 19 && dateTaken.hour < 23;
  /// Returns: true if 6AM..8PM . false = isTakenAtNight
  bool get isTakenAtDay => dateTaken.hour > 6 && dateTaken.hour < 21;

  bool get isInFavorites => Settings.favorites.contains(path);

  void addToFavorites(BuildContext context) {
    if (Settings.favorites.contains(path)) {
      Settings.favorites.remove(path);
      showStyledToast("💔 Removed from favorites", context);
    }
    else {
      Settings.favorites.add(path);
      showStyledToast("❤️ Added to favorites", context);
    }
    Settings.save();
  }

  Future<bool> showMoreActionsPopup(BuildContext context, {bool evenMoreActions = false}) async =>
    await photosMoreActionPopup(context, this, evenMoreActions);

  Future<Widget> getDetailsWidget(BuildContext context) async =>
    await getPhotoDetailsWidget(this, context);

  Future<bool> showDeletePopup(BuildContext context, Function onDelete) async {
    bool delete = await showMonoPDialog(
      context,
      title: "Delete?",
      ok: "Delete",
      cancel: "Cancel",
      child: Text("Delete $name ?")
    );

    if (delete) {
      await File(path).delete();
      if (isInFavorites)
        Settings.favorites.remove(path);
      showStyledToast("Deleted!", context);
      onDelete();
    }

    return delete;
  }

  Future<bool> showEditCommentPopup(BuildContext context, Function onEdit) async {
    var ctrlr = TextEditingController(text: await ExifInterface.getAttribute(path, ExifTag.TAG_USER_COMMENT));
    List<String> randomPlaceholders = ["Beautiful skies", "Rainy ☔", "Son 😭😭😭😭", "hehehe (●'◡'●)", "Night", "Today is ____",
      "⛅", "☀️", "💀", "That was so scary!", "Here we at ____"]; //TODO: add more

    bool edited = await showMonoPDialog(
      context,
      title: "Edit User Comment",
      ok: "Save",
      cancel: "Cancel",
      child: MonoPTextField(
        controller: ctrlr,
        maxLines: 3,
        placeholder: "${randomPlaceholders[Random.secure().nextInt(randomPlaceholders.length)]} ...",
      ),
    );

    if (edited) {
      await ExifInterface.setAttribute(path, ExifTag.TAG_USER_COMMENT, ctrlr.text);
      onEdit();
    }
      
    return edited;
  }

}