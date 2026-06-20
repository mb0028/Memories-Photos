import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';

class PhotoViewerPage extends StatelessWidget {
  final Photo photo;
  const PhotoViewerPage({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: .center,
        children: [
          Flexible(
            child: Hero(
              curve: Curves.easeOutCirc,
              reverseCurve: Curves.easeInCirc,
              tag: photo.path,
              child: Image.file(
                File(photo.path),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: .spaceBetween,
            children: [
              _Header(photo: photo,),
              _Footer(photo: photo,),
            ],
          )
        ] 
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          Flexible(
            child: Text(
              name,
              textAlign: .center,
              maxLines: 3,
            ).frosted(
              padding: .all(15),
              borderRadius: .circular(35),
              frostColor: Theme.of(context).colorScheme.tertiaryContainer
            ),
          ),
          IconButton.filledTonal(
            icon: Icon(Icons.more_vert_rounded),
            padding: .all(15),
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
  String dateTaken = "";

  void getDateTaken() async {
    var temp = await widget.photo.dateTaken;
    setState(() {
      dateTaken = temp;
    });
  }

  @override
  void initState() {
    getDateTaken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .all(15).add(.only(bottom: 40)), //TODO: adaptive nav bar padding
      child: Column(
        spacing: 5,
        children: [
          Text(dateTaken),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.share_rounded),
                onPressed: () {
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                },
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                },
              ),
              IconButton(
                icon: Icon(Icons.edit_rounded),
                onPressed: () {
                },
              ),
            ],
          ).frosted(
            borderRadius: .circular(30),
            padding: .all(10),
            frostColor: Theme.of(context).colorScheme.secondaryContainer
          ),
        ],
      ),
    );
  }
}

