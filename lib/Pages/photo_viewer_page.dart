import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Editor/editor_page.dart';
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
      // onHorizontalDragUpdate: (details) {
      //   setState(() => t = details.localPosition.dx - 200);
      // },
      // onHorizontalDragEnd: (details) {
      //   if (t > 70) {
      //     i--;
      //     setState(() => i = i.clamp(0, widget.query.length - 1));
      //   }
      //   else if (t < -70) {
      //     i++;
      //     setState(() => i = i.clamp(0, widget.query.length - 1));
      //   }
      //   t = 0;
      //   getName();
      // },
      onPanUpdate: (details) {
        setState(() => scale = (details.globalPosition.dy - 230) / 150);
      },
      onPanEnd: (details) => setState(() => scale = 1),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        
        body: Center(
          child: Stack(
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
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  IconButton.filledTonal(
                    icon: Icon(Icons.arrow_back),
                    tooltip: "Previous",
                    onPressed: () => setState(() => i = (i - 1).clamp(0, widget.query.length - 1)),
                  ),
                  IconButton.filledTonal(
                    icon: Icon(Icons.arrow_forward),
                    tooltip: "Next",
                    onPressed: () => setState(() => i = (i + 1).clamp(0, widget.query.length - 1)),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        bottomNavigationBar: _Footer(photo: widget.query[i]),
        
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            name,
            textAlign: .center,
            maxLines: 2,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              fontFamily: Settings.ElmsSans,
              fontSize: 16
            ),
          ).frosted(
            blur: 8,
            borderRadius: .circular(50),
            padding: .all(10),
            frostColor: Theme.of(context).colorScheme.tertiaryContainer
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////

class _Footer extends StatefulWidget {
  final Photo photo;
  const _Footer({required this.photo});

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  @override
  Widget build(BuildContext context) {
    double size = 26;
    return Container(
      margin: .symmetric(horizontal: 15).add(.only(bottom: MediaQuery.paddingOf(context).bottom)),
      height: 115,
      child: Column(
        spacing: 5,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.more_vert_rounded, size: size),
                tooltip: "More",
                onPressed: () => widget.photo.showMoreActionsPopup(context),
              ),
              Text(widget.photo.dateTaken.toString()),
              IconButton(
                icon: Icon(Icons.arrow_back_rounded, size: size),
                tooltip: "Back",
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ).frosted(
            blur: 8,
            padding: .symmetric(horizontal: 15, vertical: 4),
            borderRadius: .circular(50),
            frostColor: Theme.of(context).colorScheme.secondaryContainer
          ),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.draw_rounded, size: size),
                tooltip: "Edit",
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditorPage(
                    photo: widget.photo,
                  )));
                },
              ),
              IconButton(
                icon: Icon(Icons.share_rounded, size: size),
                tooltip: "Share",
                onPressed: () {
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: size),
                tooltip: "Delete",
                onPressed: () {
                  widget.photo.showDeletePopup(context, () => setState(() {}));
                },
              ),
              IconButton(
                icon: Icon(Icons.info_outline, size: size),
                tooltip: "Info",
                onPressed: () {
                  widget.photo.showDetailsPopup(context);
                },
              ),
              IconButton(
                icon: Icon(widget.photo.isInFavorites ? Icons.favorite_rounded : Icons.favorite_border, size: size),
                tooltip: "Add/Remove favorite",
                onPressed: () {
                  setState(() => widget.photo.addToFavorites(context));
                },
              ),
              IconButton(
                icon: Icon(Icons.insert_comment_outlined, size: size),
                tooltip: "Change Comment",
                onPressed: () {
                  widget.photo.showEditCommentPopup(context, () => setState(() {}));
                },
              ),
            ],
          ).frosted(
            blur: 8,
            borderRadius: .circular(50),
            padding: .symmetric(horizontal: 10, vertical: 4),
            frostColor: Theme.of(context).colorScheme.primaryContainer
          ),
        ],
      ),
    );
  }
}

