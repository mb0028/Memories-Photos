// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/ExifInterface/exif_interface.dart';
import 'package:memories_photos/ExifInterface/tags.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Scripts/android_helper.dart';
import 'package:memories_photos/Widgets/expressive_button.dart';
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
    padding: .only(top: MediaQuery.paddingOf(context).top + 5),
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
        Text(path, textAlign: .center),
        Divider(),
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              comment.isNotEmpty ? Padding(
                padding: .symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  comment,
                  textAlign: .center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: Settings.ElmsSans
                  ),
                ),
              ) : SizedBox(),

              ExpressiveButton.top(
                text: "${await File(path).length()} bytes\n${x}x$y  •  ${((xi * yi) / 1000000).round()} MP", 
                icon: Icon(Icons.photo_size_select_large, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 15.5,
                onClick: () {},
              ),

              photoGSens.isNotEmpty || mm.isNotEmpty || ev.isNotEmpty || f.isNotEmpty || ss.isNotEmpty ? ExpressiveButton(
                text: "$photoGSens ISO  •  ${mm}mm  •  $ev ev\n${f}f  •  $ss s$flashText", 
                icon: Icon(Icons.camera_outlined, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 15.5,
                onClick: () {},
              ) : SizedBox(),

              make.isNotEmpty || model.isNotEmpty || softwere.isNotEmpty ? ExpressiveButton(
                text: "$make  •  $model\n$softwere", 
                icon: Icon(Icons.camera_enhance_outlined, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 14,
                onClick: () {},
              ) : SizedBox(),

              zoom.isNotEmpty || aper.isNotEmpty ? ExpressiveButton(
                text: "Digital zoom ratio: $zoom\nAperture: $aper  •  Max $maxAper", 
                icon: Icon(Icons.forest_outlined, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 14,
                onClick: () {},
              ) : SizedBox(),

              sceneText.isNotEmpty || meterinText.isNotEmpty ? ExpressiveButton(
                text: "Scene capture type: $sceneText\nMetering mode: $meterinText",
                fontSize: 14,
                onClick: () {},
              ) : SizedBox(),

              lat.isNotEmpty ? ExpressiveButton(
                text: "Lat: $lat ($latRef)\nLong: $long ($longRef)\nAlt: $alt\nClick icon to open in google maps", 
                icon: Icon(Icons.location_searching_outlined, size: 28, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 13.5,
                onClick: () => AndroidHelper.openWithMaps(lat, long),
              ) : SizedBox(),

              SizedBox(height: 50)
            ],
          ),
        ),
        
        Platform.isWindows ? IconButton.filled(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_rounded),
          tooltip: "Close",
        ) : SizedBox(),

        Divider(),        
        Text(
          "  Image Unique ID: $uniID", 
          maxLines: 2,
          overflow: .fade,
        ),
        SizedBox(height: MediaQuery.paddingOf(context).bottom),
      ],
    ),
  );
}
