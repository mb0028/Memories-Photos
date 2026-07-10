import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:memories_photos/Widgets/blur.dart';

void showStyledToast(String text, BuildContext context, {int duration = 3}) {
  showToastWidget(
    Container(
      margin: .only(top: 80),
      child: BlurredContainerMonoP(
        padding: .symmetric(vertical: 8, horizontal: 15),
        color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(90),
        roundneess: 25,
        border: .all(
          width: 2,
          color: Colors.white
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
        ),
      )
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