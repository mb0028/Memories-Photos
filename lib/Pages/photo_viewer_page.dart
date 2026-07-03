import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/main.dart';
import 'package:memories_photos/settings.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
  Widget? details;

  void getName() async {
    var temp = await widget.query[i].commentOrName;
    setState(() {
      name = temp;
    });
  }

  void adaptColor() async {
    ColorScheme colorScheme = await ColorScheme.fromImageProvider(
      provider: FileImage(File(widget.query[i].path)),
      dynamicSchemeVariant: .rainbow,
      brightness: MainAppState.brightness,
    );
    if (Settings.adaptiveColors)
      Future.delayed(Duration(milliseconds: 10), () => MainAppState.instance!.setColorSeed(colorScheme.primaryContainer));
  }

  @override
  void initState() {
    i = widget.i;
    getName();
    super.initState();
    adaptColor();
  }
  @override
  void dispose() {
    super.dispose();

    if (Settings.adaptiveColors)
    Future.delayed(Duration(milliseconds: 10), () => MainAppState.instance!.chnageColorSeed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: _Footer(photo: widget.query[i]),
      
      body: Center(
        child: PhotoViewGallery.builder(
          itemCount: widget.query.length,
          gaplessPlayback: true,
          enableRotation: Settings.allowRotateInPView,
          scrollPhysics: BouncingScrollPhysics(),
          pageController: PageController(initialPage: i),
          onPageChanged: (index) => i = index,
          
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface
          ),
          builder: (context, index) => PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(widget.query[index].path)),
            heroAttributes: PhotoViewHeroAttributes(tag: widget.query[index]),
          ),
        ),
      ),
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: .center,
          children: [
            Column(
              crossAxisAlignment: .stretch,
              children: [
                Text(
                  name,
                  textAlign: .center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    fontFamily: Settings.ElmsSans,
                    fontSize: 16
                  ),
                ),
                Text(
                  widget.query[i].dateTaken.toString(),
                  textAlign: .center,
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    fontFamily: Settings.CherryBombOne,
                    fontSize: 16
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded, size: 28),
                  tooltip: "Back",
                  onPressed: () => Navigator.of(context).pop(),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert_rounded, size: 28),
                  tooltip: "More",
                  onPressed: () => widget.query[i].showMoreActionsPopup(context),
                ),
              ],
            ), //TODO: Windows Next/Previous button
            // Row(
            //   mainAxisAlignment: .spaceBetween,
            //   children: [
            //     IconButton.filledTonal(
            //       icon: Icon(Icons.arrow_back),
            //       tooltip: "Previous",
            //       onPressed: () {
            //         setState(() => i = (i - 1).clamp(0, widget.query.length - 1));
            //         getName();
            //       },
            //     ),
            //     IconButton.filledTonal(
            //       icon: Icon(Icons.arrow_forward),
            //       tooltip: "Next",
            //       onPressed: () {
            //         setState(() => i = (i + 1).clamp(0, widget.query.length - 1));
            //         getName();
            //       },
            //     ),
            //   ],
            // ),
          ],
        ).frosted(
          blur: 8,
          borderRadius: .circular(50),
          padding: .all(10),
          frostColor: Theme.of(context).colorScheme.tertiaryContainer
        ),
      ),
    
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(220),
        width: 360,
        child: details,
      ),
      onDrawerChanged: (isOpened) async {
        if (isOpened) {
          var v = await widget.query[i].getDetailsWidget(context);
          setState(() => details = v);
        }
      },
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
    double size = 28;
    return Container(
      margin: .symmetric(horizontal: 15).add(.only(bottom: MediaQuery.paddingOf(context).bottom + 15)),
      height: 55,
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
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
              Scaffold.of(context).openDrawer();
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
    );
  }
}
