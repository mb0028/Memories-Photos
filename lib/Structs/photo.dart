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

  Future<DateTime> get dateTakenOrFileTime async {
    String ds = await dateTaken;
    if (ds.isNotEmpty) {
      DateTime? d = DateTime.tryParse(ds.replaceAll(":", "").replaceAll(" ", "T"));
      if (d != null) return d;
    }
    return await File(path).lastModified();
  }

  /// Returns: true if 5..9 AM
  Future<bool> get isTakenAtMorning async {
    String ds = await dateTaken;
    if (ds.isEmpty) return false;
    DateTime? d = DateTime.tryParse(ds.replaceAll(":", "").replaceAll(" ", "T"));
    if (d != null && d.hour > 5 && d.hour < 10)
      return true;
    return false;
  }
  /// Returns: true if 7..10 PM
  Future<bool> get isTakenAtEvening async {
    String ds = await dateTaken;
    if (ds.isEmpty) return false;
    DateTime? d = DateTime.tryParse(ds.replaceAll(":", "").replaceAll(" ", "T"));
    if (d != null && d.hour > 19 && d.hour < 23)
      return true;
    return false;
  }
  /// Returns: true if 6AM..8PM . false = isTakenAtNight
  Future<bool> get isTakenAtDay async {
    String ds = await dateTaken;
    if (ds.isEmpty) return false;
    DateTime? d = DateTime.tryParse(ds.replaceAll(":", "").replaceAll(" ", "T"));
    if (d != null && d.hour > 6 && d.hour < 21)
      return true;
    return false;
  }

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