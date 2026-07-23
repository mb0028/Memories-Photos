import 'package:flutter/material.dart';
import 'package:memories_photos/Scripts/android_helper.dart';
import 'package:memories_photos/main.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});
  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool hasFileAccess = false;

  void init() async {
    var b = await AndroidHelper.isExternalStorageManager();
    setState(() => hasFileAccess = b);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 15,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Text(hasFileAccess ? "Permission Granted!" : "All files access is needed"),
        
            !hasFileAccess ? FilledButton(
              onPressed: () => AndroidHelper.openAllFilesAccess(), 
              child: Text("Open Settings")
            ) : SizedBox(),
            !hasFileAccess ? OutlinedButton(
              onPressed: () => init(), 
              child: Text("Refresh")
            ) : SizedBox(),
            hasFileAccess ? OutlinedButton(
              onPressed: () => setState(() => MainAppState.instance!.setState(() => MainAppState.instance!.hasFileAccess = true)), 
              child: Text("Restart App")
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }
}