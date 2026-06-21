import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memories_photos/Structs/photo.dart';
import 'package:memories_photos/Widgets/home_page_photo_card.dart';
import 'package:memories_photos/photo_indexer.dart';
import 'package:memories_photos/settings.dart';

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

  Future<void> refresh() async {
    recents = []; sunrise = []; night = [];
    int sunriseCount = 0; int nightCount = 0;

    for (var i = 0; i < Settings.recentsCount; i++)
      recents.add(PhotoIndexer.photos[(PhotoIndexer.photos.length - 1) - i]);
    
    for (var p in PhotoIndexer.photos) {
      if (sunriseCount >= Settings.specialSectionsCount && nightCount >= Settings.specialSectionsCount)
        break;

      if(await p.isTakenAtMorning && sunriseCount < Settings.specialSectionsCount) {
        sunrise.add(p);
        sunriseCount++;
      } else if(!await p.isTakenAtDay && nightCount < Settings.specialSectionsCount) {
        night.add(p);
        nightCount++;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await refresh(),
      elevation: 0,
      child: ListView(
        padding: .only(bottom: 280),
        children: [
          SizedBox(
            height: 220,
            child: Image.file(
              File(PhotoIndexer.photos[Random.secure().nextInt(PhotoIndexer.photos.length)].path),
              fit: .cover,
            ),
          ),
          Text(
            "Memories Photos",
            textAlign: .center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 28,
              fontWeight: .bold
            ),
          ),
          SizedBox(height: 30),
      
          _SectionHeader(text: "Recent Photos"),
          _Section(photos: recents, flexWeights: [1, 3, 1]),
      
          _SectionHeader(text: "Sunrise Takes"),
          _Section(photos: sunrise, flexWeights: [2, 4, 1]),
      
          _SectionHeader(text: "Night Takes"),
          _Section(photos: night, flexWeights: [1, 4, 2])
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
      child: Expanded(
        child: CarouselView.weightedBuilder(
          itemCount: photos.length,
          flexWeights: flexWeights,
          itemSnapping: true,
          infinite: photos.length > 1,
          itemBuilder: (context, i) => HomePagePhotoCard(photo: photos[i]),
        ),
      )
    );
  }
}