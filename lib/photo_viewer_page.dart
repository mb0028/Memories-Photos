import 'dart:io';
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
        children: [
          IconButton.filled(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(path.substring(path.lastIndexOf(Platform.pathSeparator) + 1)),
          IconButton.filledTonal(
            icon: Icon(Icons.more_vert_rounded),
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
      padding: .all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(220),
        borderRadius: .all(.circular(30))
      ),
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
