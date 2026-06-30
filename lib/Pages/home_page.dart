import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:memories_photos/Pages/albums_page.dart';
import 'package:memories_photos/Pages/home_page_contents.dart';
import 'package:memories_photos/Pages/photos_page.dart';
import 'package:memories_photos/Popups/home_create_new_popup.dart';

class MonoPHomePage extends StatefulWidget {
  const MonoPHomePage({super.key});

  @override
  State<MonoPHomePage> createState() => MonoPHomePageState();
}

class MonoPHomePageState extends State<MonoPHomePage> {
  int currentPage = 0;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await showHomeCreateNewPopup(context))
            setState(() {});
        },
        tooltip: "Create",
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        child: Icon(Icons.add_a_photo_outlined, color: Theme.of(context).colorScheme.onTertiaryContainer,),
      ),
      bottomSheet: Container(
        margin: .all(15).add(.only(bottom: MediaQuery.paddingOf(context).bottom)),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withAlpha(60),
            borderRadius: .circular(80),
            border: .all(
              color: Theme.of(context).colorScheme.secondaryContainer,
              width: 3
            )
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            selectedIndex: currentPage,
            height: 65,
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
          borderRadius: .circular(80)
        ),
      ),
    );
  }
}
