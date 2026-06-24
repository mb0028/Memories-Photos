import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/settings.dart';

class PhotoViewerPage extends StatefulWidget {
  final List<Photo> query;
  final int i; 
  const PhotoViewerPage({super.key, required this.query, required this.i});

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  int i = 0;
  String name = "";
  double t = 0;
  double scale = 1;

  void getName() async {
    var temp = await widget.query[i].commentOrName;
    setState(() {
      name = temp;
    });
  }

  @override
  void initState() {
    i = widget.i;
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() => t = details.localPosition.dx - 200);
      },
      onHorizontalDragEnd: (details) {
        if (t > 90) {
          i--;
          setState(() => i = i.clamp(0, widget.query.length - 1));
        }
        else if (t < -90) {
          i++;
          setState(() => i = i.clamp(0, widget.query.length - 1));
        }
        t = 0;
        getName();
      },
      onPanUpdate: (details) {
        setState(() => scale = (details.globalPosition.dy - 230) / 150);
      },
      onPanEnd: (details) => setState(() => scale = 1),
      child: Scaffold(
        body: Stack(
          alignment: .center,
          children: [
            Transform.scale(
              scale: scale,
              child: Transform.translate(
                offset: Offset(t, 0),
                child: Hero(
                  curve: Curves.easeOutCirc,
                  reverseCurve: Curves.easeInCirc,
                  tag: widget.query[i].path,
                  child: Image.file(
                    File(widget.query[i].path),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: .spaceBetween,
              children: [
                _Header(photo: widget.query[i], name: name),
                _Footer(photo: widget.query[i]),
              ],
            )
          ] 
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////

class _Header extends StatelessWidget {
  final Photo photo;
  final String name;
  const _Header({required this.photo, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .all(15).add(.only(top: 20)),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        spacing: 15,
        children: [
          IconButton.filled(
            icon: Icon(Icons.arrow_back_rounded),
            padding: .all(15),
            tooltip: "Back",
            onPressed: () => Navigator.of(context).pop(),
          ),
          Flexible(
            child: Container(
              padding: .all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(220),
                borderRadius: .circular(50),
                // border: .all(
                //   width: 1,
                //   color: Theme.of(context).colorScheme.tertiary
                // )
              ),
              child: Text(
                name,
                textAlign: .center,
                maxLines: 3,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  fontFamily: Settings.ElmsSans
                ),
              ),
            )
          ),
          IconButton.filledTonal(
            icon: Icon(Icons.more_vert_rounded),
            padding: .all(15),
            tooltip: "More",
            onPressed: () => photo.showMoreActionsPopup(context),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatefulWidget {
  final Photo photo;
  const _Footer({required this.photo});

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .all(15).add(.only(bottom: 40)), //TODO: adaptive nav bar padding
      child: Column(
        spacing: 5,
        children: [
          Text(widget.photo.dateTaken.toString()).frosted(
            blur: 8,
            padding: .symmetric(horizontal: 15, vertical: 8),
            borderRadius: .circular(20),
            frostColor: Theme.of(context).colorScheme.tertiaryContainer
          ),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.share_rounded, size: 24),
                tooltip: "Share",
                onPressed: () {
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 28),
                tooltip: "Delete",
                onPressed: () {
                  widget.photo.showDeletePopup(context, () => setState(() {}));
                },
              ),
              IconButton(
                icon: Icon(Icons.info_outline, size: 32),
                tooltip: "Info",
                onPressed: () {
                  widget.photo.showDetailsPopup(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite_border, size: 28),
                tooltip: "Add/Remove favorite",
                onPressed: () {
                },
              ),
              IconButton(
                icon: Icon(Icons.draw_rounded, size: 24),
                tooltip: "Change Comment",
                onPressed: () {
                  widget.photo.showEditCommentPopup(context, () => setState(() {}));
                },
              ),
            ],
          ).frosted(
            blur: 4,
            borderRadius: .circular(50),
            padding: .all(10),
            frostColor: Theme.of(context).colorScheme.secondaryContainer
          ),
        ],
      ),
    );
  }
}

