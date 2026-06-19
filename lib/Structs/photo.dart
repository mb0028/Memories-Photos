import 'dart:io';

/// Holds path to the photo and helpful methods. <br/>
/// F**k dart with this lowercase naming rule
class Photo {
  final String path;
  Photo({required this.path});

  String get name => path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
  String get commentOrName => name; //TODO: Implement

  //TODO: Exif

  /// Returns: true if 5..9 AM
  bool get isTakenAtMorning => false; //TODO: Implement
  /// Returns: true if 7..10 PM
  bool get isTakenAtEvening => false; //TODO: Implement
  /// Returns: true if 6AM..8PM . false = isTakenAtNight
  bool get isTakenAtDay => false; //TODO: Implement

  DateTime get tryGetDateTaken {
    return .now(); //TODO: Implement
  }

  void showMoreActionsPopup({bool evenMoreActions = false}) {
    //TODO: Implement
  }

  void showDetailsPopup() {
    //TODO: Implement
  }

  void showRenamePopup() {
    //TODO: Implement
  }

  void showEditCommentPopup() {
    //TODO: Implement
  }


}