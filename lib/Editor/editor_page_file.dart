import 'package:flutter/material.dart';

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
      builder: (context, controller, child) => IconButton(
          focusNode: _buttonFocusNode,
          tooltip: "File",
          icon: Icon(Icons.insert_drive_file_outlined),
          onPressed: () {
            if (controller.isOpen)
              controller.close();
            else
              controller.open();
          },
        ),
    );
  }
}
