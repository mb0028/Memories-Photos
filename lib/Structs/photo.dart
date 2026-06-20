import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/ExifInterface/exif_interface.dart';
import 'package:memories_photos/ExifInterface/tags.dart';

/// Holds path to the photo and helpful methods. <br/>
/// F**k dart with this lowercase naming rule
class Photo {
  final String path;
  Photo({required this.path});
  
  String get name => path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
  
  Future<String> get commentOrName async {
    String comment = await ExifInterface.getAttribute(path, ExifTag.TAG_USER_COMMENT);
    if (comment.isNotEmpty)
      return comment;
    return name;
  }

  Future<String> get dateTaken async => await ExifInterface.getAttribute(path, ExifTag.TAG_DATETIME_ORIGINAL);

  /// Returns: true if 5..9 AM
  bool get isTakenAtMorning => false; //TODO: Implement
  /// Returns: true if 7..10 PM
  bool get isTakenAtEvening => false; //TODO: Implement
  /// Returns: true if 6AM..8PM . false = isTakenAtNight
  bool get isTakenAtDay => false; //TODO: Implement

  Future<Map<String, String>?> get exif async => await ExifInterface.getUsefulExif(path);


  void showMoreActionsPopup(BuildContext context, {bool evenMoreActions = false}) {
    //TODO: Implement
  }

  void showDetailsPopup(BuildContext context) {
    //TODO: Implement
  }

  void showRenamePopup(BuildContext context) {
    //TODO: Implement
  }

  void showEditCommentPopup(BuildContext context) {
    //TODO: Implement
  }


}