import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/ExifInterface/exif_interface.dart';
import 'package:memories_photos/ExifInterface/tags.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/settings.dart';

Future<Widget> getPhotoDetailsWidget(Photo photo, BuildContext context) async {
  var path = photo.path;
  var x = await ExifInterface.getAttribute(path, ExifTag.TAG_PIXEL_X_DIMENSION);
  var y = await ExifInterface.getAttribute(path, ExifTag.TAG_PIXEL_Y_DIMENSION);
  int xi = int.tryParse(x) ?? 1; int yi = int.tryParse(y) ?? 1;

  var photoGSens = await ExifInterface.getAttribute(path, ExifTag.TAG_PHOTOGRAPHIC_SENSITIVITY);
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

  return Container(
    margin: .all(10),
    padding: .only(top: 50),
    child: Column(
      spacing: 3,
      children: [
        Text(
          photo.dateTaken.toString(),
          style: TextStyle(
            fontSize: 19,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            fontFamily: Settings.CherryBombOne,
          ),
        ),
        Text(path),
        Divider(),
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              comment.isNotEmpty ? _DetailsTile(
                text: comment,
                icon: Icon(Icons.mode_comment_outlined, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 14,
                font: Settings.ElmsSans,
              ) : SizedBox(),

              _DetailsTile(
                text: "${File(path).lengthSync()} bytes\n${x}x$y  •  ${((xi * yi) / 1000000).round()} MP", 
                icon: Icon(Icons.photo_size_select_large, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 15.5,
              ),

              photoGSens.isNotEmpty || mm.isNotEmpty || ev.isNotEmpty || f.isNotEmpty || ss.isNotEmpty ? _DetailsTile(
                text: "$photoGSens ISO  •  ${mm}mm  •  $ev ev\n${f}f  •  $ss s$flashText", 
                icon: Icon(Icons.camera_outlined, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 15.5,
              ) : SizedBox(),

              make.isNotEmpty || model.isNotEmpty || softwere.isNotEmpty ? _DetailsTile(
                text: "$make  •  $model\n$softwere", 
                icon: Icon(Icons.camera_alt_outlined, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 14,
              ) : SizedBox(),

              zoom.isNotEmpty || aper.isNotEmpty ? _DetailsTile(
                text: "Digital zoom ratio: $zoom\nAperture: $aper  •  Max $maxAper", 
                icon: Icon(Icons.photo_camera_front, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 14,
              ) : SizedBox(),

              sceneText.isNotEmpty || meterinText.isNotEmpty ? _DetailsTile(
                text: "Scene capture type: $sceneText\nMetering mode: $meterinText",
                icon: Icon(Icons.landscape_outlined, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 14,
              ) : SizedBox(),

              SizedBox(height: 50)
            ],
          ),
        ),

        Divider(),

        lat.isNotEmpty ? _DetailsTile(
          text: "Lat: $lat ($latRef)\nLong: $long ($longRef)\nAlt: $alt", 
          icon: IconButton.filledTonal(
            icon: Icon(Icons.location_searching_outlined, size: 28, color: Theme.of(context).colorScheme.onSecondaryContainer),
            onPressed: () {},
            tooltip: "Open in google maps",
          ),
          fontSize: 14,
        ) : SizedBox(),

        uniID.isNotEmpty ? Text("Image Unique ID: $uniID") : SizedBox(),

        Row(
          mainAxisAlignment: .end,
          children: [
            IconButton.filled(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_rounded),
              tooltip: "Close",
            )
          ],
        ),
        SizedBox(height: MediaQuery.paddingOf(context).bottom),
      ],
    ),
  );
}

// ignore: must_be_immutable
class _DetailsTile extends StatelessWidget {
  _DetailsTile({
    required this.text, required this.icon, required this.fontSize, this.font
  });
  final Widget icon;
  final String text;
  final double fontSize;
  String? font = Settings.LexendDeca;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .symmetric(vertical: 10),
      padding: .all(7.5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(90),
        borderRadius: .circular(18)
      ),
      child: Row(
        spacing: 15,
        children: [
          icon,
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: fontSize,
                fontFamily: font
              ),
              maxLines: 3,
              overflow: .ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}