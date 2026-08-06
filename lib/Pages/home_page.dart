import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories_photos/Pages/More/albums_page.dart';
import 'package:memories_photos/Pages/More/camera_timelapse_page.dart';
import 'package:memories_photos/Pages/home_page_contents.dart';
import 'package:memories_photos/Pages/photos_page.dart';
import 'package:memories_photos/Scripts/camera_helper.dart';
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
      
      drawer: _HomeDrawer(),

      bottomSheet: Padding(
        padding: .only(bottom: MediaQuery.paddingOf(context).bottom + 5),
        child: Row(
          mainAxisAlignment: .center,
          spacing: 10,
          children: [
            BlurredContainer(
              blur: 10,
              color: Theme.of(context).colorScheme.surfaceBright.withAlpha(180),
              roundneess: 50 * Settings.rm,
              width: 280,
              child: NavigationBar(
                labelBehavior: .onlyShowSelected,
                backgroundColor: Colors.transparent,
                selectedIndex: currentPage,
                height: 70,
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
            ),
            IconButton.filledTonal(
              padding: .all(12),
              icon: Icon(Icons.search_rounded, size: 33),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            icon: Icon(Icons.auto_graph_rounded),
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
            ),
          ),
          ExpressiveButton(
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
        ],
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
        SizedBox(height: 55),
        FloatingActionButton(
          onPressed: () => CameraHelper.takePicture(context),
          tooltip: "Create",
          heroTag: "Create",
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: Icon(Icons.add_a_photo_outlined, color: Theme.of(context).colorScheme.onTertiaryContainer),
        ),
        FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraTakeTimelapsePage())),
          tooltip: "Create Timelapse",
          heroTag: "CreateTimelapse",
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(Icons.timelapse_rounded, color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ],
    );
  }
}
