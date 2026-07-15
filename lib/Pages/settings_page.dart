import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memories_photos/Popups/change_accent_popup.dart';
import 'package:memories_photos/Popups/path_picker_popup.dart';
import 'package:memories_photos/Widgets/colorful_bg.dart';
import 'package:memories_photos/main.dart';
import 'package:memories_photos/settings.dart';
import 'package:open_filex/open_filex.dart';
import 'package:silky_scroll/silky_scroll.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int a = 220;

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
      extendBodyBehindAppBar: true,
      body: ColorfulBackground(
        child: Container(
          padding: .symmetric(horizontal: 15),
          child: SilkyListView(
            scrollSpeed: 1.5,
            physics: BouncingScrollPhysics(),
            children: [
              uiSettings(),
              SizedBox(height: 15),
              mainSettings(),
              SizedBox(height: 15),
              libSettings(),
              SizedBox(height: 8),
              FilledButton(
                onPressed: () => OpenFilex.open(Settings.settingsFile.path),
                child: Text(Platform.isWindows ? "Edit Settings.txt" : "View Settings.txt"),
              ),
              SizedBox(height: 8),
              Text("Settings file path: ${Settings.settingsFile.path}"),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget uiSettings() {
    return Container(
      padding: .all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(a),
        borderRadius: .circular(25 * Settings.rm)
      ),
      child: Column(
        children: [
          ListTile(
            title: Text("Adaptive coloring"),
            subtitle: Text("UI by default will uses device accent color. When viewing photos, color adapts to image accent color\nAFFACTS PERFORMANCE", style: TextStyle(fontSize: 12)),
            leading: Switch(
              value: Settings.adaptiveColors,
              onChanged: (value) {
                setState(() => Settings.adaptiveColors = value);
                Settings.save();
                MainAppState.instance!.changeColorSeed();
              },
            ),
          ),
          !Settings.adaptiveColors ? ListTile(
            title: Text("Accent Color"),
            subtitle: OutlinedButton(
              child: Text("Change"),
              onPressed: () async {
                var col = await showChangeAccentColorPopup(context);
                if (col.$2) {
                  setState(() => Settings.accent = col.$1);
                  Settings.save();
                  MainAppState.instance!.changeColorSeed();
                }
              },
            ),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Settings.accent,
                border: .all(width: 2),
                borderRadius: .circular(15 * Settings.rm)
              ),
            ),
            trailing: IconButton.outlined(
              icon: Icon(Icons.sync_rounded),
              tooltip: "Reset",
              onPressed: () {
                setState(() => Settings.accent = Settings.defaultColor);
                  Settings.save();
                MainAppState.instance!.changeColorSeed();
              }, 
            ),
          ) : SizedBox(),
          ListTile(
            title: Text("Corner Roundness: ${(Settings.rm * 100).round()}%"),
            subtitle: Slider(
              min: 0.05,
              max: 3.0,
              showValueIndicator: .alwaysVisible,
              value: Settings.rm.toDouble(),
              onChanged: (value) {
                setState(() => Settings.rm = value);
                Settings.save();
              },
            ),
          ),
        ]
      )
    );
  }

  Widget mainSettings() {
    return Container(
      padding: .all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(a),
        borderRadius: .circular(25 * Settings.rm)
      ),
      child: Column(
        children: [
          ListTile(
            title: Text("Rotatable photos"),
            subtitle: Text("When on: allows to rotate photos when viewing it fullscreen", style: TextStyle(fontSize: 12)),
            leading: Switch(
              value: Settings.allowRotateInPView,
              onChanged: (value) {
                setState(() => Settings.allowRotateInPView = value);
                Settings.save();
              },
            ),
          ),
          ListTile(
            title: Text("Shuffle special sections"),
            subtitle: Text("Shuffle homepage special sections (like sunrise & night sections)", style: TextStyle(fontSize: 12)),
            leading: Switch(
              value: Settings.specialSectionsShuffle,
              onChanged: (value) {
                setState(() => Settings.specialSectionsShuffle = value);
                Settings.save();
              },
            ),
          ),
          ListTile(
            title: Text("Trash instead of delete"),
            subtitle: Text("Move photos to trash instead of deleting (Coming soon)", style: TextStyle(fontSize: 12)),
            leading: Switch(
              value: Settings.trashInstead,
              onChanged: (value) {
                setState(() => Settings.trashInstead = value);
                Settings.save();
              },
            ),
          ),
          ListTile(
            title: Text("Show hidden photos"),
            subtitle: Text("Not works as excepted. don't turn it on until next updates", style: TextStyle(fontSize: 12)),
            leading: Switch(
              value: Settings.showHidden,
              onChanged: (value) {
                setState(() => Settings.showHidden = value);
                Settings.save();
              },
            ),
          ),
          ListTile(
            title: Text("Max home recent items: ${Settings.recentsCount}"),
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
            title: Text("Max home special sections items: ${Settings.specialSectionsCount}"),
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
            title: Text("Max image editor undo count: ${Settings.maxUndoCount}"),
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
        ],
      ),
    );
  }

  Widget libSettings() {
    return Container(
      padding: .all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(a),
        borderRadius: .circular(25 * Settings.rm)
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          ListTile(
            title: Text(Platform.isAndroid ? "Only show DCIM photos" : "Only show Desktop photos"),
            leading: Switch(
              value: Settings.onlyShowDCIM,
              onChanged: (value) {
                setState(() => Settings.onlyShowDCIM = value);
                Settings.save();
              },
            ),
          ),
          !Settings.onlyShowDCIM ? Text("Library include folders:") : SizedBox(),
          !Settings.onlyShowDCIM ? ElevatedButton(
            onPressed: () async {
              var t = await showPathPickerDialog(context);
              if (t != null && !Settings.libInclude.contains(t))
                setState(() => Settings.libInclude.add(t));
              Settings.save();
            },
            child: Text("Add")
          ) : SizedBox(),
          !Settings.onlyShowDCIM ? SizedBox(
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
                  tooltip: "Remove",
                  icon: Icon(Icons.remove_circle_outline),
                  color: Theme.of(context).colorScheme.error,
                  highlightColor: Theme.of(context).colorScheme.errorContainer,
                ) : null,
              ),
            ),
          ) : SizedBox(),
          SizedBox(height: 15,),
          Text("Library exclude folders:"),
          ElevatedButton(
            onPressed: () async {
              var t = await showPathPickerDialog(context);
              if (t != null && !Settings.libExclude.contains(t))
                setState(() => Settings.libExclude.add(t));
              Settings.save();
            },
            child: Text("Add")
          ),
          SizedBox(
            height: 160,
            child: ListView.builder(
              itemCount: Settings.libExclude.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(Settings.libExclude[i]),
                leading: IconButton(
                  onPressed: () {
                    setState(() => Settings.libExclude.remove(Settings.libExclude[i]));
                    Settings.save();
                  },
                  tooltip: "Remove",
                  icon: Icon(Icons.remove_circle_outline),
                  color: Theme.of(context).colorScheme.error,
                  highlightColor: Theme.of(context).colorScheme.errorContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}