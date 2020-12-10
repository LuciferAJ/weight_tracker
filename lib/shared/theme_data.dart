import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_tracker/shared/theme_colors.dart';

ThemeData weightTrackerTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    backgroundColor: primaryColor,
    primaryColor: primaryColor,
    iconTheme: IconThemeData(
      color: primaryColor,
    ),
    accentColor: accentColor,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      elevation: 0,
    ),
    buttonColor: accentColor,
    buttonTheme: ButtonThemeData(
      buttonColor: accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      textTheme: ButtonTextTheme.primary,
      splashColor: Colors.teal,
    ),
    textTheme: TextTheme(
        headline1: TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    )));
