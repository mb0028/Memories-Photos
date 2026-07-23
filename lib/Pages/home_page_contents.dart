import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/photo_card_home_page.dart';
import 'package:memories_photos/photo_indexer.dart';
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
  double bannerBlur = 0;

  Future<void> refresh() async {
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

      if (await p.megaPixels >= 48 && hqCount < Settings.specialSectionsCount) {
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
    scroll.addListener(() => setState(() => bannerBlur = (scroll.position.pixels * 0.3).clamp(0, 30) ));
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
              Text("No images found 😭😭\nGo to 'Settings -> Library include' then add folders you want to show in app.", textAlign: .center,),
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
          Transform.scale(
            scale: 1.1,
            alignment: .bottomCenter,
            child: SizedBox(
              height: 150,
              child: header != null ? ImageFiltered(
                imageFilter: .blur(sigmaX: bannerBlur, sigmaY: 0),
                child: Image.file(
                  File(header!.path),
                  fit: .cover,
                ),
              ) : SizedBox(),
            ),
          ),
          Transform.scale(
            scale: 1 - (bannerBlur * 0.07).clamp(0, 1),
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
      
          _SectionHeader(text: "Recent Photos"),
          _Section(photos: recents, flexWeights: [1, 3, 1]),
      
          sunrise.isNotEmpty ? _SectionHeader(text: "Sunrise Captures") : SizedBox(), // TODO: better naming + random section names
          sunrise.isNotEmpty ? _Section(photos: sunrise, flexWeights: [1, 3, 1]) : SizedBox(),
      
          night.isNotEmpty ? _SectionHeader(text: "Night Captures") : SizedBox(), // TODO: better naming + random section names
          night.isNotEmpty ? _Section(photos: night, flexWeights: [1, 3, 1]) : SizedBox(),

          highRes.isNotEmpty ? _SectionHeader(text: "High Quality") : SizedBox(), // TODO: better naming + random section names
          highRes.isNotEmpty ? _Section(photos: highRes, flexWeights: [1, 3, 1]) : SizedBox(),
        ],
      ),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: .center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 20
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
