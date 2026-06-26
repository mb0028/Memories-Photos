import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/add_path_popup.dart';
import 'package:memories_photos/settings.dart';
import 'package:open_filex/open_filex.dart';

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
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            SizedBox(height: 15,),
            Text("Library include folders:"),
            ElevatedButton(
              onPressed: () async {
                var t = await showAddPathDialog(context);
                if (t != null && !Settings.libInclude.contains(t))
                  setState(() => Settings.libInclude.add(t));
              },
              child: Text("Add")
            ),
            SizedBox(
              height: 160,
              child: ListView.builder(
                itemCount: Settings.libInclude.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text(Settings.libInclude[i]),
                  leading: Settings.libInclude.length > 1 ? IconButton(
                    onPressed: () {
                      setState(() => Settings.libInclude.remove(Settings.libInclude[i]));
                      Settings.save();
                    },
                    icon: Icon(Icons.remove_circle_outline),
                    color: Theme.of(context).colorScheme.error,
                    highlightColor: Theme.of(context).colorScheme.errorContainer,
                  ) : null,
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Library exclude folders:"),
            ElevatedButton(
              onPressed: () async {
                var t = await showAddPathDialog(context);
                if (t != null && !Settings.libExclude.contains(t))
                  setState(() => Settings.libExclude.add(t));
              },
              child: Text("Add")
            ),
            SizedBox(
              height: 160,
              child: ListView.builder(
                itemCount: Settings.libExclude.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text(Settings.libExclude[i]),
                  leading: Settings.libExclude.length > 1 ? IconButton(
                    onPressed: () {
                      setState(() => Settings.libExclude.remove(Settings.libExclude[i]));
                      Settings.save();
                    },
                    icon: Icon(Icons.remove_circle_outline),
                    color: Theme.of(context).colorScheme.error,
                    highlightColor: Theme.of(context).colorScheme.errorContainer,
                  ) : null,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => OpenFilex.open(Settings.settingsFile.path),
              child: Text("Edit Settings.txt"),
            ),
            SizedBox(height: 8,),
            Text("Location: ${Settings.settingsFile.path}"),
            SizedBox(height: 250,)
          ],
        ),
      ),
    );
  }
}