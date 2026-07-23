import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/blur.dart';
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
    Future.delayed(Duration(milliseconds: 10), () => MainAppState.instance!.changeColorSeed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      
      body: Stack(
        alignment: .bottomCenter,
        children: [
          Center(
            child: PhotoViewGallery.builder(
              itemCount: widget.query.length,
              gaplessPlayback: true,
              enableRotation: Settings.allowRotateInPView,
              scrollPhysics: BouncingScrollPhysics(),
              pageController: PageController(initialPage: i),
              onPageChanged: (index) {
                i = index;
                getName();
                adaptColor();
              },
              
              backgroundDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface
              ),
              builder: (context, index) => PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(widget.query[index].path)),
                heroAttributes: PhotoViewHeroAttributes(tag: widget.query[index]),
              ),
            ),
          ),
          _Footer(photo: widget.query[i])
        ],
      ),
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: Platform.isAndroid ? 90 : 130,
        automaticallyImplyLeading: false,
        title: BlurredContainerMonoP(
          blur: 10,
          roundneess: 50 * Settings.rm,
          padding: .all(10),
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(140),
          child: Column(
            spacing: 5,
            crossAxisAlignment: .stretch,
            children: [
              Padding(
                padding: .symmetric(horizontal: 50),
                child: Text(
                  name,
                  textAlign: .center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontFamily: Settings.ElmsSans,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                widget.query[i].dateTaken.toString(),
                textAlign: .center,
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontFamily: Settings.CherryBombOne,
                  fontSize: 16
                ),
              ),
            ],
          ),
        ),
        leading: IconButton.filledTonal(
          icon: Icon(Icons.arrow_back_rounded, size: 28),
          tooltip: "Back",
          onPressed: () => Navigator.of(context).pop(),
        ),
        actionsPadding: .only(right: 5),
        actions: [
          IconButton.filledTonal(
            icon: Icon(Icons.more_vert_rounded, size: 28),
            tooltip: "More",
            onPressed: () => widget.query[i].showMoreActionsPopup(context),
          ),
        ],
      ),
    
      drawer: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: .only(topRight: .circular(45 * Settings.rm), bottomRight: .circular(45 * Settings.rm)),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(245),
        width: 380,
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
    return BlurredContainerMonoP(
      blur: 10,
      width: 230,
      height: 55,
      roundneess: 50 * Settings.rm,
      margin: .symmetric(horizontal: 15).add(.only(
        bottom: MediaQuery.paddingOf(context).bottom + (Platform.isWindows ? 15 : 0)
      )),
      color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(140),
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
      )
    );
  }
}
