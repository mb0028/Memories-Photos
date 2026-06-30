
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:memories_photos/settings.dart';

Future<(Color, bool)> showChangeAccentColorPopup(BuildContext context) async {
  var col = Settings.accent;
  bool save = false;
  await showDialog(context: context, builder: (context) => Dialog(
  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    child: Container(
      width: 400,
      height: 600,
      padding: .all(15),
      child: ListView(
        children: [
          ColorPicker(
            pickerColor: Settings.accent,
            enableAlpha: false,
            paletteType: .hslWithLightness,
            onColorChanged: (value) {
              col = value;
            },
          ),
          FilledButton(
            child: Text("Save"),
            onPressed: () {
              save = true;
              Navigator.of(context).pop();
            },
          ),
        ],
      )
    )
  ));
  return (col, save);
}