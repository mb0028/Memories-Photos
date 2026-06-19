import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/albums_page.dart';
import 'package:memories_photos/Pages/home_page_contents.dart';
import 'package:memories_photos/Pages/photos_page.dart';
import 'package:memories_photos/photo_indexer.dart';

class MonoPHomePage extends StatefulWidget {
  const MonoPHomePage({super.key});

  @override
  State<MonoPHomePage> createState() => MonoPHomePageState();
}

class MonoPHomePageState extends State<MonoPHomePage> {
  int currentPage = 0;

  @override
  void initState() {
    PhotoIndexer.startCa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (currentPage) {
        0 => HomePageContents(),
        1 => PhotosPage(),
        2 => AlbumsPage(),
        int() => throw UnimplementedError(),
      },
      extendBody: true,
      bottomNavigationBar: Container(
        margin: .all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(80),
            borderRadius: .circular(50),
            border: .all(
              color: Theme.of(context).colorScheme.secondaryContainer,
              width: 2
            )
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            selectedIndex: currentPage,
            onDestinationSelected: (value) {
              setState(() {
                currentPage = value;
              });
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.star_outline_rounded),
                selectedIcon: Icon(Icons.star_rounded),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(Icons.photo_outlined),
                selectedIcon: Icon(Icons.photo_rounded),
                label: "Photos"
              ),
              NavigationDestination(
                icon: Icon(Icons.photo_album_outlined),
                selectedIcon: Icon(Icons.photo_album_rounded),
                label: "Albums"
              ),
            ]
          ),
        ).frosted(
          blur: 4,
          borderRadius: .circular(50)
        ),
      ),
    );
  }
}

