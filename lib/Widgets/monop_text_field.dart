import 'package:flutter/material.dart';
import 'package:memories_photos/settings.dart';

// ignore: must_be_immutable
class MonoPTextField extends StatelessWidget {
  final TextEditingController controller;
  int? maxLines = 1;
  String? placeholder;
  MonoPTextField({super.key, required this.controller, this.maxLines, this.placeholder});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: placeholder,
        border: OutlineInputBorder(
          borderRadius: .circular(15 * Settings.rm),
        ),
      ),
    );
  }
}