import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:memories_photos/main.dart';

class ColorfulBackground extends StatelessWidget {
  final Widget? child;
  const ColorfulBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ColorfulBackgroundPainter(
        color: Theme.of(context).colorScheme.surface,
        shader: colorfulBackgroundProgram.fragmentShader(),
      ),
      child: child,
    );
  }
}

class ColorfulBackgroundPainter extends CustomPainter{
  final Color color;
  final FragmentShader shader;
  const ColorfulBackgroundPainter({required this.color, required this.shader});
  
  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, color.r);
    shader.setFloat(3, color.g);
    shader.setFloat(4, color.b);
    shader.setFloat(5, color.a);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }
  
  @override
  bool shouldRepaint(ColorfulBackgroundPainter oldDelegate) => true;
  
}