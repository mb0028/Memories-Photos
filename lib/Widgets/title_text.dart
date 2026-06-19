import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color color;
  const TitleText({
    super.key, required this.text, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: 90),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: .only(bottomLeft: .circular(25), bottomRight: .circular(25))
      ),
      child: Text(
        text,
        textAlign: .center,
         style: TextStyle(
          fontSize: 28,
          fontWeight: .w900,
          color: color
        ),
      ),
    );
  }
}