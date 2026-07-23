import 'package:flutter/material.dart';
import 'package:memories_photos/settings.dart';

class CollageMakerPage extends StatelessWidget {
  const CollageMakerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      bottomSheet: Container(
        margin: .all(15).add(.only(bottom: MediaQuery.paddingOf(context).bottom + 5)),
        child: Row(
          mainAxisAlignment: .spaceEvenly,
          children: [
            IconButton.outlined(
              icon: Icon(Icons.filter),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            OutlinedButton.icon(
              icon: Icon(Icons.grid_4x4_rounded),
              label: Text(
                "Select Images",
                style: TextStyle(
                  fontFamily: Settings.CherryBombOne,
                  fontSize: 17
                ),
              ),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}