import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memories_photos/ExifInterface/exif_interface.dart';
import 'package:memories_photos/ExifInterface/tags.dart';
import 'package:memories_photos/Widgets/monop_text_field.dart';

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


  void showMoreActionsPopup(BuildContext context, {bool evenMoreActions = false}) {
    //TODO: Implement
  }

  void showDetailsPopup(BuildContext context) async {
    var x = await ExifInterface.getAttribute(path, ExifTag.TAG_PIXEL_X_DIMENSION);
    var y = await ExifInterface.getAttribute(path, ExifTag.TAG_PIXEL_Y_DIMENSION);

    var iso = await ExifInterface.getAttribute(path, ExifTag.TAG_PHOTOGRAPHIC_SENSITIVITY);
    var ev = await ExifInterface.getAttribute(path, ExifTag.TAG_EXPOSURE_BIAS_VALUE);
    var ss = await ExifInterface.getAttribute(path, ExifTag.TAG_SHUTTER_SPEED_VALUE);
    var f = await ExifInterface.getAttribute(path, ExifTag.TAG_F_NUMBER);
    var mm = await ExifInterface.getAttribute(path, ExifTag.TAG_FOCAL_LENGTH_IN_35MM_FILM);

    var comment = await ExifInterface.getAttribute(path, ExifTag.TAG_USER_COMMENT);
    var make = await ExifInterface.getAttribute(path, ExifTag.TAG_MAKE);
    var model = await ExifInterface.getAttribute(path, ExifTag.TAG_MODEL);
    var softwere = await ExifInterface.getAttribute(path, ExifTag.TAG_SOFTWARE);
    var zoom = await ExifInterface.getAttribute(path, ExifTag.TAG_DIGITAL_ZOOM_RATIO);
    var aper = await ExifInterface.getAttribute(path, ExifTag.TAG_APERTURE_VALUE);
    var maxAper = await ExifInterface.getAttribute(path, ExifTag.TAG_MAX_APERTURE_VALUE);
    var uniID = await ExifInterface.getAttribute(path, ExifTag.TAG_IMAGE_UNIQUE_ID);

    var lat = await ExifInterface.getAttribute(path, ExifTag.TAG_GPS_LATITUDE);
    var long = await ExifInterface.getAttribute(path, ExifTag.TAG_GPS_LONGITUDE);
    var alt = await ExifInterface.getAttribute(path, ExifTag.TAG_GPS_ALTITUDE);
    var latRef = await ExifInterface.getAttribute(path, ExifTag.TAG_GPS_LATITUDE_REF);
    var longRef = await ExifInterface.getAttribute(path, ExifTag.TAG_GPS_LONGITUDE_REF);

    var flash = await ExifInterface.getAttribute(path, ExifTag.TAG_FLASH);
    var flashText = switch (flash) {
      "24" => "  •  Flash used (auto)",
      "1" => "  •  Flash used",
      _ =>  ""
    };

    var scene = await ExifInterface.getAttribute(path, ExifTag.TAG_SCENE_CAPTURE_TYPE);
    var sceneText = switch (scene) {
      "0" => "Standart",
      "1" => "Landscape",
      "2" => "Portrait",
      "3" => "Night",
      _ =>  ""
    };

    var meterin = await ExifInterface.getAttribute(path, ExifTag.TAG_METERING_MODE);
    var meterinText = switch (meterin) {
      "0" => "Unknown",
      "1" => "Average",
      "2" => "Center weight average",
      "3" => "Spot",
      "4" => "Multi spot",
      "5" => "Pattern",
      "6" => "Partial",
      "255" => "Other",
      _ =>  ""
    };

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(230),
      
      builder: (context) => Container(
        margin: .symmetric(horizontal: 10),
        height: 480,
        child: Column(
          spacing: 8,
          children: [
            Text(
              dateTaken.toString(),
              style: TextStyle(
                fontSize: 26,
                fontWeight: .bold
              ),
            ),
            Text(path),
            Divider(),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  _DetailsTile(
                    text: "Comment: $comment",
                    icon: Icon(Icons.mode_comment_outlined, size: 42, color: Theme.of(context).colorScheme.primary.withAlpha(200)),
                    fontSize: 15,
                  ),

                  _DetailsTile( //TODO: Add Size + megapixels
                    text: "00.0 mb  •  ${x}x$y\nISO $iso  •  ${mm}mm  •  $ev ev\n${f}f  •  $ss s$flashText", 
                    icon: Icon(Icons.camera_outlined, size: 42, color: Theme.of(context).colorScheme.primary),
                    fontSize: 18,
                  ),

                  lat.isNotEmpty ?  _DetailsTile(
                    text: "Lat:$lat ($latRef)\nLong:$long ($longRef)\nAlt:$alt", 
                    icon: IconButton.filledTonal(
                      icon: Icon(Icons.location_searching_outlined, size: 28, color: Theme.of(context).colorScheme.primary),
                      onPressed: () {},
                      tooltip: "Open in google maps",
                    ),
                    fontSize: 15,
                  ) : SizedBox(),

                  _DetailsTile(
                    text: "$make  •  $model\n$softwere", 
                    icon: Icon(Icons.camera_alt_outlined, size: 42, color: Theme.of(context).colorScheme.secondary),
                    fontSize: 15,
                  ),

                  _DetailsTile(
                    text: "Digital zoom ratio: $zoom\nAperture: $aper  •  Max $maxAper", 
                    icon: Icon(Icons.photo_camera_front, size: 42, color: Theme.of(context).colorScheme.tertiary),
                    fontSize: 15,
                  ),

                  _DetailsTile(
                    text: "Scene capture type: $sceneText\nMetering mode: $meterinText\nImage Unique ID: $uniID",
                    icon: Icon(Icons.landscape_outlined, size: 42, color: Theme.of(context).colorScheme.tertiary),
                    fontSize: 15,
                  ),

                  SizedBox(height: 50)
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<bool> showDeletePopup(BuildContext context, Function onDelete) async {
    bool deleted = false;
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Container(
          height: 200,
          padding: .all(15),
          child: Column(
            spacing: 15,
            children: [
              Text(
                "Delete?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: .bold
                ),
              ),
              Flexible(child: Text("Delete $path ?")),
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: FilledButton(
                      child: Text("Delete"),
                      onPressed: () async {
                        await File(path).delete();
                        deleted = true;
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: FilledButton.tonal(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (deleted)
      onDelete();
    return deleted;
  }

  Future<bool> showEditCommentPopup(BuildContext context, Function onEdit) async {
    var comment = await ExifInterface.getAttribute(path, ExifTag.TAG_USER_COMMENT);
    var ctrlr = TextEditingController();
    ctrlr.text = comment;
    bool edited = false;

    List<String> randomPlaceholders = ["Beautiful skies", "Rainy ☔", "Son 😭😭😭😭", "hehehe (●'◡'●)", "Night", "Today is ____",
      "⛅", "☀️", "💀", "That was so scary!", "Here we at ____"]; //TODO: add more
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Container(
          height: 250,
          padding: .all(15),
          child: Column(
            spacing: 15,
            children: [
              Text(
                "Change User Comment",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: .bold
                ),
              ),
              MonoPTextField(
                controller: ctrlr,
                maxLines: 3,
                placeholder: "${randomPlaceholders[Random.secure().nextInt(randomPlaceholders.length)]} ...",
              ),
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: FilledButton(
                      child: Text("Save"),
                      onPressed: () async {
                        await ExifInterface.setAttribute(path, ExifTag.TAG_USER_COMMENT, ctrlr.text);
                        edited = true;
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: FilledButton.tonal(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (edited)
      onEdit();
    return edited;
  }

}

class _DetailsTile extends StatelessWidget {
  const _DetailsTile({
    required this.text, required this.icon, required this.fontSize,
  });
  final Widget icon;
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .symmetric(vertical: 11),
      child: Row(
        spacing: 15,
        children: [
          icon,
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize),
              maxLines: 3,
              overflow: .ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}