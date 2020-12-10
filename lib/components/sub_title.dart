import 'package:flutter/material.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

Widget customSubTitle(data, context) {
  return Text(
    data,
    style: trackerTheme(context).subtitle1.apply(
          fontSizeDelta: 2,
          fontSizeFactor: 1.1,
          color: Colors.white38,
        ),
  );
}
