import 'package:flutter/material.dart';

Future<bool> showMonoPDialog(
  BuildContext context,
  {
    Widget? child,
    String? title,
    String? ok,
    String? cancel
  }
) async {
  bool result = false;
  
  await showRawDialog(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      title: title == null ? null : Text(title, textAlign: .center,),
      elevation: 1.5,
      contentPadding: .symmetric(horizontal: 18, vertical: 12),
      children: [
        child ?? SizedBox(height: 20),
        SizedBox(height: 30, width: 300,),
        Row(
          mainAxisAlignment: .end,
          spacing: 5,
          children: [
            cancel != null ? FilledButton.tonal(
              onPressed: () {
                result = false;
                Navigator.of(context).pop();
              },
              child: Text(cancel)
            ) : SizedBox(),
            ok != null ? FilledButton.tonal(
              onPressed: () {
                result = true;
                Navigator.of(context).pop();
              },
              child: Text(ok)
            ) : SizedBox(),
          ],
        )
      ],
    ),
  );

  return result;
}