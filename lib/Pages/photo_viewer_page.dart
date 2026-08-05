import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/More/editor_page.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/blur.dart';
import 'package:memories_photos/Popups/photo_details.dart';
import 'package:memories_photos/main.dart';
import 'package:memories_photos/settings.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerPage extends StatefulWidget {
  final Set<Photo> query;
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
    final temp = await widget.query.elementAt(i).commentOrName;
    setState(() => name = temp);
  }

  void adaptColor() async {
    ColorScheme colorScheme = await ColorScheme.fromImageProvider(
      provider: FileImage(File(widget.query.elementAt(i).path)),
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
                imageProvider: FileImage(File(widget.query.elementAt(index).path)),
                heroAttributes: PhotoViewHeroAttributes(tag: widget.query.elementAt(index)),
              ),
            ),
          ),
          _Footer(
            photo: widget.query.elementAt(i),
            onUpdate: () => setState(() {}),
          )
        ],
      ),
      
      appBar: Platform.isWindows || MediaQuery.orientationOf(context) == .portrait ? _Appbar() : null,
    );
  }

  // ignore: non_constant_identifier_names
  AppBar _Appbar() {
    final photo = widget.query.elementAt(i);
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      toolbarHeight: Platform.isAndroid ? 90 : 130,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: BlurredContainer(
        blur: 10,
        roundneess: 35 * Settings.rm,
        padding: .all(10),
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(140),
        child: Column(
          spacing: 5,
          crossAxisAlignment: .stretch,
          children: [
            Text(
              "${photo.dateTaken.year}/${photo.dateTaken.month}/${photo.dateTaken.day} ${photo.dateTaken.hour}:${photo.dateTaken.minute}:${photo.dateTaken.second}",
              textAlign: .center,
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontFamily: Settings.CherryBombOne,
                fontSize: 16
              ),
            ),
            Text(
              name,
              textAlign: .center,
              maxLines: 2,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 16,
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
      actionsPadding: .only(right: 5, left: 3),
      actions: [
        IconButton.filledTonal(
          icon: Icon(Icons.more_vert_rounded, size: 28),
          tooltip: "More",
          onPressed: () => widget.query..elementAt(i).showMoreActionsPopup(context),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////////

class _Footer extends StatelessWidget {
  final Photo photo;
  final Function onUpdate;
  const _Footer({required this.photo, required this.onUpdate});
  @override
  Widget build(BuildContext context) {
    double size = 28;
    return BlurredContainer(
      blur: 10,
      width: 265,
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
            onPressed: () async {
              await photo.showDeletePopup(context);
              onUpdate();
            },
          ),
          IconButton(
            icon: Icon(photo.isInFavorites ? Icons.favorite_rounded : Icons.favorite_border, size: size),
            tooltip: "Add/Remove favorite",
            onPressed: () {
              photo.addToFavorites(context);
              onUpdate();
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline, size: size),
            tooltip: "Info",
            onPressed: () async {
              await showPhotoDetails(photo, context);
              onUpdate();
            },
          ),
          IconButton(
            icon: Icon(Icons.draw_rounded, size: size),
            tooltip: "Change Comment",
            onPressed: () async {
              await photo.showEditCommentPopup(context);
              onUpdate();
            },
          ),
          IconButton(
            icon: Icon(Icons.crop_rounded, size: size),
            tooltip: "Edit",
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditorPage(photo: photo))),
          ),
        ],
      )
    );
  }
}
