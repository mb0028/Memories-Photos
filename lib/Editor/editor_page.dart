import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:memories_photos/Editor/filters.dart';
import 'package:memories_photos/Popups/toast.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/monop_text_field.dart';
import 'package:memories_photos/settings.dart';
import 'package:image/image.dart' as img;

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, this.photo});
  final Photo? photo;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  File tempP = File("${Settings.appCache}/temp.png");
  List<Uint8List> undoHistory = [];
  double? loading = 1;
  
  @override
  void initState() {
    if (!tempP.existsSync())
      tempP.createSync();

    if (widget.photo != null) {
      File(widget.photo!.path).copySync(tempP.path);
      undoHistory.add(tempP.readAsBytesSync());
    }
      
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit ${widget.photo?.name}"),
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.insert_drive_file_outlined),
              tooltip: "File",
              onPressed: () {
                
              },
            ),
          ],
        ),
        actionsPadding: .only(right: 6),
        actions: [
          IconButton(
            icon: Icon(Icons.undo_rounded),
            tooltip: "Undo",
            onPressed: () => undo(),
          )
        ],
      ),
      bottomSheet: Container(
        margin: .all(15).add(.only(bottom: 30)), //TODO: adaptive nav bar padding
        height: 80,
        child: Column(
          spacing: 10,
          children: [
            LinearProgressIndicator(value: loading, minHeight: 8, borderRadius: .circular(20),),
            Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.aspect_ratio_outlined, size: 38,),
                  tooltip: "Resize",
                  onPressed: () => resize(false),
                ),
                OutlinedButton(
                  child: Text("BW"),
                  onPressed: () async {
                    setState(() => loading = null);
                    await recordHistory();
                    await Filters.bw(tempP.path);
                    setState(() => loading = 1);
                  },
                ),
                 OutlinedButton(
                  child: Text("Grayscale"),
                  onPressed: () async {
                    setState(() => loading = null);
                    await recordHistory();
                    await Filters.grayscale(tempP.path);
                    setState(() => loading = 1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: widget.photo == null ? pickupBtn() : Center(
        child: Flexible(
          child: Image.memory(
            File(tempP.path).readAsBytesSync()
          ),
        ),
      ),
    );
  }

  Widget pickupBtn() {
    return Center(
      child: OutlinedButton.icon(
        icon: Icon(Icons.image),
        label: Text(
          "Select Image",
          style: TextStyle(
            fontFamily: Settings.CherryBombOne,
            fontSize: 17
          ),
        ),
        onPressed: () {
        },
      ),
    );
  }

  Future<void> recordHistory() async {
    if (undoHistory.length < Settings.maxUndoCount)
      undoHistory.add(await tempP.readAsBytes());
    else {
      undoHistory.removeAt(0);
      undoHistory.add(await tempP.readAsBytes());
    }
  }

  void undo() async {
    if (undoHistory.length <= 1)
      return;
    setState(() => loading = null);
    await tempP.writeAsBytes(undoHistory.removeLast());
    setState(() => loading = 1);
  }

  ////////////////////////////////////////////////////////////////
  
  Future<void> resize(bool crop) async {
    setState(() => loading = null);
    var ctW = TextEditingController();
    var ctH = TextEditingController();
    bool edit = false;

    await showDialog(context: context, builder: (context) => Dialog(
      child: Container(
        padding: .all(15),
        width: 300,
        height: 280,
        child: Column(
          mainAxisAlignment: .center,
          spacing: 10,
          children: [
            Text(crop ? "Crop" : "Resize", style: TextStyle(fontSize: 22),),
            MonoPTextField(controller: ctW, placeholder: "Width",),
            MonoPTextField(controller: ctH, placeholder: "Height",),
            FilledButton(
              onPressed: () {
                edit = true;
                Navigator.of(context).pop();
              },
              child: Text("Ok")
            )
          ],
        ),
      ),
    ));

    if (edit) {
      try {
        var w = int.parse(ctW.text);
        var h = int.parse(ctH.text);
        await recordHistory();
        var cmd = img.Command()
          ..decodeImageFile(tempP.path)
          ..copyResize(width: w, height: h, interpolation: .linear)
          ..encodePngFile(tempP.path, level: 9);
        await cmd.executeThread();
      } on Exception catch (e) {
        showStyledToast(e.toString(), context, duration: 5);
      }
    }

    setState(() => loading = 1);
  }

}