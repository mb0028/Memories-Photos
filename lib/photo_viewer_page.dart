import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class PhotoViewerPage extends StatelessWidget {
  final String path;
  const PhotoViewerPage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: .center,
        children: [
          Flexible(
            child: Hero(
              curve: Curves.elasticOut,
              reverseCurve: Curves.elasticIn,
              tag: path,
              child: Image.file(
                File(path),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: .spaceBetween,
            children: [
              _Header(path: path,),
              _Footer(),
            ],
          )
        ] 
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////

class _Header extends StatelessWidget {
  final String path;
  const _Header({required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .all(15),
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
              path.substring(path.lastIndexOf(Platform.pathSeparator) + 1),
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
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }
}


class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .all(15),
      child: Row(
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
    );
  }
}

// class _PhotoInfoDrawer extends StatelessWidget {
//   final String path;
//   const _PhotoInfoDrawer({required this.path});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
