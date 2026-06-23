import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';

class PhotoViewerPage extends StatefulWidget {
  final List<Photo> query;
  final int i; 
  const PhotoViewerPage({super.key, required this.query, required this.i});

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  int i = 0;

  @override
  void initState() {
    i = widget.i;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // print(details);
        if (details.velocity.pixelsPerSecond.dx < 400)
          setState(() {
            i++;
            i = i.clamp(0, widget.query.length - 1);
          });
        else if (details.velocity.pixelsPerSecond.dx > -400)
          setState(() {
            i--;
            i = i.clamp(0, widget.query.length - 1);
          });
      },
      child: Scaffold(
        body: Stack(
          alignment: .center,
          children: [
            Hero(
              curve: Curves.easeOutCirc,
              reverseCurve: Curves.easeInCirc,
              tag: widget.query[i].path,
              child: Image.file(
                File(widget.query[i].path),
              ),
            ),
            Column(
              mainAxisAlignment: .spaceBetween,
              children: [
                _Header(photo: widget.query[i]),
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

class _Header extends StatefulWidget {
  final Photo photo;
  const _Header({required this.photo});

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  String name = "";

  void getName() async {
    var temp = await widget.photo.commentOrName;
    setState(() {
      name = temp;
    });
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

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
                  color: Theme.of(context).colorScheme.onTertiaryContainer
                ),
              ),
            )
          ),
          IconButton.filledTonal(
            icon: Icon(Icons.more_vert_rounded),
            padding: .all(15),
            tooltip: "More",
            onPressed: () => widget.photo.showMoreActionsPopup(context),
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
            blur: 10,
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
            blur: 10,
            borderRadius: .circular(50),
            padding: .all(10),
            frostColor: Theme.of(context).colorScheme.secondaryContainer
          ),
        ],
      ),
    );
  }
}

