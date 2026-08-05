import 'dart:io';
import 'dart:ui';
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
  FragmentProgram? colorfulBackgroundProgram;
  
  void loadBG() async {
    colorfulBackgroundProgram = await FragmentProgram.fromAsset("Assets/Shaders/bg.frag");
    setState(() {});
  }

  @override
  void initState() {
    loadBG();
    super.initState();
  }

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
      body: colorfulBackgroundProgram == null ? SizedBox() : ColorfulBackground(
        colorfulBackgroundProgram: colorfulBackgroundProgram!,
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

              Settings.inAppCamera ? cameraSettings() : SizedBox(),
              SizedBox(height: Settings.inAppCamera ? 15 : 0),
              
              libSettings(),
              SizedBox(height: 8),

              FilledButton(
                onPressed: () => OpenFilex.open(Settings.settingsFile.path),
                child: Text(Platform.isWindows ? "Edit Settings.txt" : "View Settings.txt"),
              ),
              SizedBox(height: 8),
              Text("Settings file path: ${Settings.settingsFile.path}\n\nApp files path: ${Settings.appPath}\n\nApp cache path: ${Settings.appCache}"),
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
          Divider(),
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
          Divider(),
          ListTile(
            title: Text("Blur Effect"),
            subtitle: Text("Not affacts performance that much. even on low-end devices", style: TextStyle(fontSize: 12)),
            leading: Switch(
              value: Settings.uiBlur,
              onChanged: (value) {
                setState(() => Settings.uiBlur = value);
                Settings.save();
                MainAppState.instance!.changeColorSeed();
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
            subtitle: Text("Move photos to trash instead of deleting it.", style: TextStyle(fontSize: 12)),
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
            leading: Switch(
              value: Settings.showHidden,
              onChanged: (value) {
                setState(() => Settings.showHidden = value);
                Settings.save();
              },
            ),
          ),
          Divider(),
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
          Divider(),
          ListTile(
            title: Text("In-App Camera"),
            subtitle: Text("Use in app camera instead of switching to phone's default camera app", style: TextStyle(fontSize: 12)),
            leading: Switch(
              value: Settings.inAppCamera,
              onChanged: (value) {
                setState(() => Settings.inAppCamera = value);
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
          Divider(),
          Text("Library exclude folders:"),
          SizedBox(height: 5),
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

  Widget cameraSettings() {
    return Container(
      padding: .all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(a),
        borderRadius: .circular(25 * Settings.rm)
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Text("In-app camera settings"),
          ListTile(
            title: Text("Edit Comment Instantly"),
            subtitle: Text("Show edit comment panel right after taking picture", style: TextStyle(fontSize: 12)),
            leading: Switch(
              value: Settings.editCommentAfterCamPic,
              onChanged: (value) {
                setState(() => Settings.editCommentAfterCamPic = value);
                Settings.save();
              },
            ),
          ),
        
        ],
      ),
    );
  }

}