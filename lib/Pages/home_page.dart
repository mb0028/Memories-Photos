import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories_photos/Pages/More/albums_page.dart';
import 'package:memories_photos/Pages/More/trash_page.dart';
import 'package:memories_photos/Pages/home_page_contents.dart';
import 'package:memories_photos/Pages/photos_page.dart';
import 'package:memories_photos/Pages/settings_page.dart';
import 'package:memories_photos/Popups/home_create_new_popup.dart';
import 'package:memories_photos/Widgets/blur.dart';
import 'package:memories_photos/Widgets/expressive_button.dart';
import 'package:memories_photos/settings.dart';
import 'package:url_launcher/url_launcher.dart';

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
      extendBody: true,
      floatingActionButton: _FloatingBtn(),
      
      body: Stack(
        alignment: .center,
        children: [
          SizedBox(
            width: MediaQuery.widthOf(context),
            height: MediaQuery.heightOf(context),
            child: Image.asset(
              "Assets/BG.png",
              fit: .cover,
            ),
          ),
          switch (currentPage) {
            0 => HomePageContents(),
            1 => PhotosPage(),
            2 => AlbumsPage(),
            int() => throw UnimplementedError(),
          },
        ],
      ),
      
      drawer: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: .only(topRight: .circular(35 * Settings.rm), bottomRight: .circular(35 * Settings.rm)),
        ),
        elevation: 0,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  "Memories Photos",
                  style: TextStyle(
                    fontFamily: Settings.CherryBombOne,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ExpressiveButton.top(
              text: "About",
              icon: Icon(Icons.code_rounded),
              onClick: () => showAboutDialog(
                context: context,
                applicationName: "Memories Photos",
                applicationVersion: "Developer: mb28",
                applicationIcon: SizedBox(
                  width: 60,
                  height: 60,
                  child: Image(
                    image: AssetImage("Things/App Icon Base/AppRect.png")
                  ),
                ),
                children: [
                  ExpressiveButton.top(
                    text: "Source code",
                    icon: Icon(Icons.code_outlined),
                    onClick: () => launchUrl(Uri.parse("https://github.com/mb0028/Memories-Photos")),
                  ),
                  ExpressiveButton(
                    text: "Instagram (@mb_0028)",
                    onClick: () => launchUrl(Uri.parse("https://www.instagram.com/mb_0028/")),
                  ),
                  ExpressiveButton.end(
                    text: "Flutter version: ${FlutterVersion.version}",
                    onClick: () => launchUrl(Uri.parse(FlutterVersion.gitUrl ?? "https://github.com/flutter/flutter")),
                  ),
                ]
              ),
            ),
            ExpressiveButton(
              text: "Settings",
              icon: Icon(Icons.settings_rounded),
              onClick: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage())),
            ),
            ExpressiveButton(
              text: "Trash",
              icon: Icon(Icons.recycling_rounded),
              onClick: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrashPage())),
            ),
            ExpressiveButton.end(
              text: "Favorites",
              icon: Icon(Icons.favorite_outline_rounded),
              onClick: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhotosPage(folder: "[FAV]")))
            ),
          ],
        ),
      ),
      bottomSheet: _bottomSheet(context),
    );
  }

  Widget _bottomSheet(BuildContext context) {
    return BlurredContainerMonoP(
      blur: 10,
      margin: .symmetric(horizontal: 15).add(.only(
        bottom: MediaQuery.paddingOf(context).bottom + (Platform.isWindows ? 15 : 0)
      )),
      color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(160),
      roundneess: 50 * Settings.rm,
      width: 250,
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        selectedIndex: currentPage,
        height: 50,
        labelBehavior: .alwaysHide,
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
    );
  }
}

class _FloatingBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .start,
      verticalDirection: .up,
      spacing: 10,
      children: [
        SizedBox(height: 35),
        FloatingActionButton(
          onPressed: () async => await showHomeCreateNewPopup(context),
          tooltip: "Create",
          heroTag: "Create",
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: Icon(Icons.add_a_photo_outlined, color: Theme.of(context).colorScheme.onTertiaryContainer,),
        ),
        FloatingActionButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: "Drawer",
          heroTag: "Drawer",
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(Icons.more_horiz_rounded, color: Theme.of(context).colorScheme.onSecondaryContainer,),
        ),
      ],
    );
  }
}
