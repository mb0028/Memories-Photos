// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Scripts/ExifInterface/exif_interface.dart';
import 'package:memories_photos/Scripts/ExifInterface/tags.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Scripts/android_helper.dart';
import 'package:memories_photos/Widgets/blur.dart';
import 'package:memories_photos/Widgets/expressive_button.dart';
import 'package:memories_photos/settings.dart';
import 'package:silky_scroll/silky_scroll.dart';

Future<void> showPhotoDetails(Photo photo, BuildContext context) async {
  var path = photo.path;
  var x = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_PIXEL_X_DIMENSION);
  var y = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_PIXEL_Y_DIMENSION);
  int xi = int.tryParse(x) ?? 1; int yi = int.tryParse(y) ?? 1;
  String size = (await File(path).length() / 1024 / 1024).toString();

  
  var timeOffset = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_OFFSET_TIME_ORIGINAL);

  var photoGSens = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_PHOTOGRAPHIC_SENSITIVITY);
  var ev = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_EXPOSURE_BIAS_VALUE);
  var ss = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_SHUTTER_SPEED_VALUE);
  var f = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_F_NUMBER);
  var mm = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_FOCAL_LENGTH_IN_35MM_FILM);

  var comment = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_USER_COMMENT);
  var make = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_MAKE);
  var model = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_MODEL);
  var softwere = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_SOFTWARE);
  var zoom = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_DIGITAL_ZOOM_RATIO);
  var aper = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_APERTURE_VALUE);
  var maxAper = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_MAX_APERTURE_VALUE);
  var uniID = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_IMAGE_UNIQUE_ID);

  var lat = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_GPS_LATITUDE);
  var long = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_GPS_LONGITUDE);
  var alt = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_GPS_ALTITUDE);
  var latRef = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_GPS_LATITUDE_REF);
  var longRef = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_GPS_LONGITUDE_REF);
  var desc = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_IMAGE_DESCRIPTION);

  var flash = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_FLASH);
  var flashText = switch (flash) {
    "24" => "  •  Flash used (auto)",
    "1" => "  •  Flash used",
    _ =>  ""
  };

  var scene = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_SCENE_CAPTURE_TYPE);
  var sceneText = switch (scene) {
    "0" => "Standart",
    "1" => "Landscape",
    "2" => "Portrait",
    "3" => "Night",
    _ =>  ""
  };

  var meterin = await ExifInterfaceOLD.getAttribute(path, ExifTagOLD.TAG_METERING_MODE);
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

  showBottomSheet(context: context, builder: (context) => BlurredContainer(
    padding: .only(top: 10),
    height: 600,
    color: Theme.of(context).colorScheme.surfaceContainerLow.withAlpha(180),
    roundneess: 35,
    child: Column(
      spacing: 3,
      children: [
        SizedBox(
          width: 60,
          child: Divider(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(160),
            thickness: 5,
            radius: .circular(25),
          ),
        ),
        Text(
          "${photo.dateTaken.year}/${photo.dateTaken.month}/${photo.dateTaken.day} ${photo.dateTaken.hour}:${photo.dateTaken.minute}:${photo.dateTaken.second} ($timeOffset)",
          style: TextStyle(
            fontSize: 19,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            fontFamily: Settings.CherryBombOne,
          ),
        ),
        Text(path.replaceFirst("/sdcard/", ''), textAlign: .center),
        Divider(
          color: Theme.of(context).colorScheme.surfaceBright,
        ),
        Expanded(
          child: SilkyListView(
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
                text: "${size.length > 4 ? size.substring(0, 4) : size} mb\n${x}x$y  •  ${((xi * yi) / 1000000).round()} MP", 
                icon: Icon(Icons.photo_size_select_large, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 15.5,
              ),
          
              photoGSens.isNotEmpty || mm.isNotEmpty || ev.isNotEmpty || f.isNotEmpty || ss.isNotEmpty ? ExpressiveButton(
                text: "$photoGSens ISO  •  ${mm}mm  •  $ev ev\n${f}f  •  $ss s$flashText", 
                icon: Icon(Icons.camera_outlined, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 15.5,
              ) : SizedBox(),
          
              make.isNotEmpty || model.isNotEmpty || softwere.isNotEmpty ? ExpressiveButton(
                text: "$make  •  $model\n$softwere", 
                icon: Icon(Icons.camera_enhance_outlined, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 14,
              ) : SizedBox(),
          
              lat.isNotEmpty ? ExpressiveButton(
                text: "Lat: $lat ($latRef)\nLong: $long ($longRef)\nAlt: $alt\nClick to open with google maps", 
                icon: Icon(Icons.location_searching_outlined, size: 28, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 13.5,
                onClick: () => AndroidHelper.openWithMaps(lat, long),
              ) : SizedBox(),

              zoom.isNotEmpty || aper.isNotEmpty ? ExpressiveButton(
                text: "Digital zoom ratio: $zoom\nAperture: $aper  •  Max $maxAper", 
                icon: Icon(Icons.forest_outlined, size: 30, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 14,
              ) : SizedBox(),
          
              sceneText.isNotEmpty || meterinText.isNotEmpty || uniID.isNotEmpty ? ExpressiveButton(
                text: "Scene capture type: $sceneText\nMetering mode: $meterinText\nImage Unique ID: $uniID",
                fontSize: 14,
              ) : SizedBox(),
          
              desc.isNotEmpty && desc != "Taken With Memories Photos" ? ExpressiveButton(
                text: "Image Description: $desc",
                fontSize: 14,
              ) : SizedBox(),
          
              ExpressiveButton.end(
                text: "Is taken at morning: ${photo.isTakenAtMorning}\nIs taken at day: ${photo.isTakenAtDay}\nIs taken at evening: ${photo.isTakenAtEvening}", 
                icon: Icon(Icons.sunny_snowing, size: 28, color: Theme.of(context).colorScheme.onSecondaryContainer),
                fontSize: 14,
              ),
          
              SizedBox(height: 100)
            ],
          ),
        ),
      ]
    ),
  ));
}
