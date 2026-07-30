import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExpressiveButton extends StatelessWidget {
  final String text;
  final Function? onClick;
  final Widget? icon;
  final double? fontSize;
  ExpressiveButton({super.key, required this.text, this.onClick, this.icon, this.fontSize});
  int _cornersType = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick?.call(),
      child: Container(
        margin: .symmetric(horizontal: 15, vertical: 1.5),
        padding: .symmetric(horizontal: 15),
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest.withAlpha(150),
          borderRadius: switch (_cornersType) {
            0 => .only(topLeft: .circular(20), topRight: .circular(20)).add(.circular(10)),
            1 => .circular(10),
            2 => .only(bottomLeft: .circular(20), bottomRight: .circular(20)).add(.circular(10)),
            _ => .circular(0),
          }
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? 17
              ),
            ),
            icon != null ? Container(
              padding: .all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(200),
                borderRadius: .circular(15)
              ),
              child: icon
            ) : SizedBox(width: 5, height: 5)
          ],
        ),
      ),
    );
  }

  factory ExpressiveButton.top({Function? onClick, required String text, Widget? icon, double? fontSize}) {
    return ExpressiveButton(onClick: onClick, text: text, icon: icon, fontSize: fontSize).._cornersType = 0;
  }
  factory ExpressiveButton.end({Function? onClick, required String text, Widget? icon, double? fontSize}) {
    return ExpressiveButton(onClick: onClick, text: text, icon: icon, fontSize: fontSize).._cornersType = 2;
  }
  factory ExpressiveButton.custom({Function? onClick, required String text, Widget? icon, required int cornersType, double? fontSize}) {
    return ExpressiveButton(onClick: onClick, text: text, icon: icon, fontSize: fontSize).._cornersType = cornersType;
  }
}
