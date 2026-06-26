import 'package:flutter/material.dart';
import 'package:memories_photos/settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: Container(
        margin: .all(15),
        padding: .all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: .circular(25)
        ),
        child: ListView(
          children: [
            ListTile(
              title: Text("Show hidden photos"),
              subtitle: Text("Not works as excepted. don't turn it on until next updates", style: TextStyle(fontSize: 12),),
              leading: Switch(
                value: Settings.showHidden,
                onChanged: (value) {
                  setState(() => Settings.showHidden = value);
                  Settings.save();
                },
              ),
            ),
            ListTile(
              title: Text("Trash instead of delete (Coming soon)"),
              leading: Switch(
                value: Settings.trashInstead,
                onChanged: (value) {
                  setState(() => Settings.trashInstead = value);
                  Settings.save();
                },
              ),
            ),
            ListTile(
              title: Text("Only show DCIM photos (Coming soon)"),
              leading: Switch(
                value: Settings.onlyShowDCIM,
                onChanged: (value) {
                  setState(() => Settings.onlyShowDCIM = value);
                  Settings.save();
                },
              ),
            ),
            ListTile(
              title: Text("Max home recent items:"),
              subtitle: Slider(
                min: 1,
                max: 100,
                showValueIndicator: .alwaysVisible,
                value: Settings.recentsCount.toDouble(),
                onChanged: (value) {
                  setState(() => Settings.recentsCount = value.toInt());
                  Settings.save();
                },
              ),
            ),
            ListTile(
              title: Text("Max home other sections items:"),
              subtitle: Slider(
                min: 1,
                max: 100,
                showValueIndicator: .alwaysVisible,
                value: Settings.specialSectionsCount.toDouble(),
                onChanged: (value) {
                  setState(() => Settings.specialSectionsCount = value.toInt());
                  Settings.save();
                },
              ),
            ),
            ListTile(
              title: Text("Max image editor undo count:"),
              subtitle: Slider(
                min: 1,
                max: 25,
                showValueIndicator: .alwaysVisible,
                value: Settings.maxUndoCount.toDouble(),
                onChanged: (value) {
                  setState(() => Settings.maxUndoCount = value.toInt());
                  Settings.save();
                },
              ),
            ),
            FilledButton(
              onPressed: () {},
              child: Text("Edit Settings.txt"),
            ),
            Text("Location: ${Settings.settingsFile.path}")
          ],
        ),
      ),
    );
  }
}