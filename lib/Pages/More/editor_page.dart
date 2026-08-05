import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Scripts/image_helper.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/settings.dart';
import 'package:image/image.dart' as img;
import 'package:silky_scroll/silky_scroll.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, required this.photo});
  final Photo photo;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late Uint8List image;
  final cctrl = CropController();
  bool loading = false;

  @override
  void initState() {
    image = File(widget.photo.path).readAsBytesSync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.set_meal_rounded),
            tooltip: "Adjustments",
            onPressed: () => _edit(adjustment: true),
          ),
        ],
      ),

      body: Crop(
        image: image,
        controller: cctrl,
        onCropped: (result) async {
          if (result is CropSuccess) {
            image = result.croppedImage;
            setState(() {});
          }
        }
      ),

      bottomNavigationBar: Padding(
        padding: .all(15),
        child: Row(
          mainAxisAlignment: .center,
          spacing: 5,
          children: [
            FilledButton(
              child: Text("Crop"),
              onPressed: () {
                cctrl.crop();
              },
            ),
            FilledButton(
              child: Text("Save"),
              onPressed: () {
                showStyledToast("Coming soon!", context);
              },
            ),
            FilledButton(
              child: Text("Save new"),
              onPressed: () => ImageHelper.saveImage(image, context, name: "Edited"),
            ),
          ],
        ),
      ),
    );
  }

  void _edit({
    bool adjustment = false,
  }) async {
    loading = true;
    final savePath = "${Settings.appCache}${Platform.pathSeparator}editorTemp.png";
    final cmd = img.Command();
    cmd.decodeImage(image);

    if (adjustment) {
      await _askAdjustments(context);
      cmd.adjustColor(
        brightness: _doubles[0],
        saturation: _doubles[1],
        contrast: _doubles[2],
        gamma: _doubles[3],
        hue: _doubles[4],
      );
    } 

    cmd.encodePngFile(savePath, level: 9);
    await cmd.executeThread();
    image = await File(savePath).readAsBytes();
    setState(() => loading = false);
  }
}

List<double> _doubles = [1, 1, 1, 1, 1];
Future<void> _askAdjustments(BuildContext context) async {
  _doubles = [1, 1, 1, 1, 1];

  await showDialog(context: context, builder: (context) => Dialog(
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    child: SizedBox(
      height: 400,
      child: _Sliders(),
    ),
  ));
}

class _Sliders extends StatefulWidget {
  @override
  State<_Sliders> createState() => _SlidersState();
}

class _SlidersState extends State<_Sliders> {
  @override
  Widget build(BuildContext context) {
    return SilkyListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        title: Text(switch (index) {
          0 => "Brightness",
          1 => "Saturation",
          2 => "Contrast",
          3 => "Gamma",
          4 => "Hue",
          _ => ""
        }),
        subtitle: Slider(
          value: _doubles[index],
          min: 0,
          max: 2,
          onChanged: (value) => setState(() => _doubles[index] = value)
        ),
      ),
    );
  }
}