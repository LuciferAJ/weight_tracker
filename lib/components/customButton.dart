import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

Widget customActionButton(title, action, context) {
  return Container(
    height: 38,
    width: screenWidth(context) * 0.6,
    child: FloatingActionButton.extended(
      heroTag: 'SignInButton',
      onPressed: action,
      label: Text(
        title,
        style: trackerTheme(context).subtitle2.apply(
            fontWeightDelta: 2,
            fontSizeDelta: 0.1,
            fontFamily: GoogleFonts.montserrat().fontFamily,
            fontSizeFactor: 0.9,
            letterSpacingFactor: 1.5,
            letterSpacingDelta: 1),
      ),
    ),
  );
}
