import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/photo_card_home_page.dart';
import 'package:memories_photos/Scripts/photo_indexer.dart';
import 'package:memories_photos/settings.dart';
import 'package:silky_scroll/silky_scroll.dart';

class HomePageContents extends StatefulWidget {
  const HomePageContents({
    super.key,
  });

  @override
  State<HomePageContents> createState() => _HomePageContentsState();
}

class _HomePageContentsState extends State<HomePageContents> {
  List<Photo> recents = [];
  List<Photo> sunrise = [];
  List<Photo> night = [];
  List<Photo> highRes = [];
  Photo? header;
  bool noImages = false;
  var scroll = ScrollController();
  double scrollOffset = 0;
  List<int> randomNums = [0, 0, 0];

  Future<void> refresh() async {
    randomNums = [
      Random.secure().nextInt(4),
      Random.secure().nextInt(4),
      Random.secure().nextInt(4)
    ];

    recents = []; sunrise = []; night = []; highRes = [];
    int sunriseCount = 0; int nightCount = 0; int hqCount = 0;

    await PhotoIndexer.startCache();
    var temp = PhotoIndexer.photos.toList();

    if(PhotoIndexer.photos.isEmpty) {
      setState(() => noImages = true);
      return;
    }

    header = temp[Random.secure().nextInt(temp.length)];

    for (var i = 0; i < Settings.recentsCount; i++)
      recents.add(temp[i.clamp(0, temp.length - 1)]);
    
    // Shuffle before selecting special sections photos
    if (Settings.specialSectionsShuffle) temp.shuffle();
    
    for (var p in temp) {
      if ((sunriseCount + nightCount + hqCount) > (Settings.specialSectionsCount * 3))
        break;

      if(p.isTakenAtMorning && sunriseCount < Settings.specialSectionsCount) {
        sunrise.add(p);
        sunriseCount++;
      } else if(!p.isTakenAtDay && nightCount < Settings.specialSectionsCount) {
        night.add(p);
        nightCount++;
      }

      if (await p.megaPixels >= 30 && hqCount < Settings.specialSectionsCount) {
        highRes.add(p);
        hqCount++;
      }
    }
    
    noImages = false;
    setState(() {});
  }

  @override
  void initState() {
    refresh();
    super.initState();
    scroll.addListener(() => setState(() => scrollOffset = (scroll.position.pixels * 0.006).clamp(0, 1) ));
  }

  @override
  Widget build(BuildContext context) {
    if (noImages)
      return Center(
        child: SizedBox(
          height: 200,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: .all(15),
            children: [
              Text("No images found 😵\nGo to 'Settings -> Library include' then add folders you want to show in app.", textAlign: .center,),
              OutlinedButton(
                onPressed: () => refresh(),
                child: Text("Refresh")
              )
            ],
          ),
        ),
      );

    return RefreshIndicator(
      onRefresh: () async => await refresh(),
      elevation: 0,
      child: SilkyListView(
        padding: .only(bottom: 280),
        controller: scroll,
        children: [
          SizedBox(
            height: 150,
            child: header != null ? Opacity(
              opacity: (1.2 - scrollOffset).clamp(0, 1),
              child: Image.file(
                File(header!.path),
                fit: .cover,
              ),
            ) : SizedBox(),
          ),
          Transform.scale(
            scale: 1 - scrollOffset,
            child: Text(
              "Memories Photos",
              textAlign: .center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 32,
                fontFamily: Settings.CherryBombOne
              ),
            ),
          ),
          SizedBox(height: 30),
      
          _SectionHeader(
            text: "Recent Photos",
            tip: "Last ${Settings.recentsCount} Photos across all folders",
          ),
          _Section(photos: recents, flexWeights: [1, 3, 1]),
      
          sunrise.isNotEmpty ? _SectionHeader(
            text: List.of(["Sunrise", "Morning Star", "Start of the Day", "🌄🌅"])[randomNums[0]],
            tip: "Photos that are taken between 5..10 AM"
          ) : SizedBox(),
          sunrise.isNotEmpty ? _Section(photos: sunrise, flexWeights: [1, 3, 1]) : SizedBox(),
      
          night.isNotEmpty ? _SectionHeader(
            text: List.of(["Night", "Midnight", "3 AM's Ghosts", "🌃🌉"])[randomNums[1]],
            tip: "Photos that are taken between 10 PM to 6 AM",
          ) : SizedBox(),
          night.isNotEmpty ? _Section(photos: night, flexWeights: [1, 3, 1]) : SizedBox(),

          highRes.isNotEmpty ? _SectionHeader(
            text: List.of(["High Quality", "Large File Size", ">30 Megapixels", ">30 Megapixels"])[randomNums[2]],
            tip: "Photos that have more than 30 megapixels",
          ) : SizedBox(),
          highRes.isNotEmpty ? _Section(photos: highRes, flexWeights: [1, 3, 1]) : SizedBox(),
        ],
      ),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String text;
  final String tip;
  const _SectionHeader({required this.text, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tip,
      child: Text(
        text,
        textAlign: .center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 20
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.photos, required this.flexWeights
  });
  final List<Photo> photos;
  final List<int> flexWeights;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(top: 8, bottom: 20).add(.symmetric(horizontal: 15)),
      height: 180,
      child: CarouselView.weightedBuilder(
        itemCount: photos.length,
        flexWeights: flexWeights,
        itemSnapping: true,
        itemBuilder: (context, i) => PhotoCardHomePage(query: photos, i: i),
      )
    );
  }
}
