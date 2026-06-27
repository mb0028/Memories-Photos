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
  const FileMenu({super.key});

  @override
  State<FileMenu> createState() => _FileMenuState();
}

class _FileMenuState extends State<FileMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      childFocusNode: _buttonFocusNode,
      menuChildren: [
        MenuItemButton(
          onPressed: () {},
          child: Text("Save as (Coming soon)")
        ),
        MenuItemButton(
          onPressed: () {},
          child: Text("Save (Coming soon)")
        ),
        MenuItemButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Exit")
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          focusNode: _buttonFocusNode,
          tooltip: "File",
          icon: Icon(Icons.insert_drive_file_outlined),
          onPressed: () {
            if (controller.isOpen)
              controller.close();
            else
              controller.open();
          },
        );
      },
    );
  }
}
