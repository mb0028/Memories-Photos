import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void showStyledToast(String text, BuildContext context, {int duration = 3}) {
  showToastWidget(
    Container(
      margin: .only(top: 80),
      child: Container(
        padding: .symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(90),
          borderRadius: .circular(25),
          border: .all(
            width: 2,
            color: Colors.white
          )
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
        ),
      ).frosted(
        blur: 2,
        borderRadius: .circular(25),
      ),
    ),
    context: context,
    duration: .new(seconds: duration),
    animation: .fadeScale,
    reverseAnimation: .fadeScale,
    curve: ElasticOutCurve(1.5),
    reverseCurve: ElasticOutCurve(1.5),
    position: .top,
  );
}