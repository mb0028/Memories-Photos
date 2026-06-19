import 'package:flutter/material.dart';

class MonoPTextField extends StatelessWidget {
  final TextEditingController controller;
  const MonoPTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: .circular(15),
        ),
      ),
    );
  }
}