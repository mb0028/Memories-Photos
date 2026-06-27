import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MenuEntry {
  about('About'),
  showMessage(
    'Show Message',
    SingleActivator(LogicalKeyboardKey.keyS, control: true),
  ),
  hideMessage(
    'Hide Message',
    SingleActivator(LogicalKeyboardKey.keyS, control: true),
  ),
  colorMenu('Color Menu'),
  colorRed(
    'Red Background',
    SingleActivator(LogicalKeyboardKey.keyR, control: true),
  ),
  colorGreen(
    'Green Background',
    SingleActivator(LogicalKeyboardKey.keyG, control: true),
  ),
  colorBlue(
    'Blue Background',
    SingleActivator(LogicalKeyboardKey.keyB, control: true),
  );

  const MenuEntry(this.label, [this.shortcut]);
  final String label;
  final MenuSerializableShortcut? shortcut;
}

class FileMenu extends StatefulWidget {
  const FileMenu({super.key, required this.message});

  final String message;

  @override
  State<FileMenu> createState() => _FileMenuState();
}

class _FileMenuState extends State<FileMenu> {
 
  @override
  Widget build(BuildContext context) {
    return Placeholder(); // IconButton(onPressed: onPressed, icon: icon)
        
  }
}
