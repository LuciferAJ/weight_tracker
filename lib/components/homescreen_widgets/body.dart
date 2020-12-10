import 'package:flutter/material.dart';
import 'package:weight_tracker/components/homescreen_widgets/bmi_section.dart';
import 'package:weight_tracker/components/homescreen_widgets/currentWeight.dart';
import 'package:weight_tracker/components/homescreen_widgets/greetings_section.dart';
import 'package:weight_tracker/components/homescreen_widgets/history_section.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

Widget homepageBody(context) {
  return ListView(
    padding: allSymmetric(20.0, 15.0),
    children: <Widget>[
      verticalSpace(screenHeight(context) * 0.05),
      greetings(context),
      verticalSpace(screenHeight(context) * 0.05),
      currentWeight(context),
      verticalSpace(20),
      bmiCalculator(context),
      verticalSpace(20),
      WeightHistorySection(),
      verticalSpace(50)
    ],
  );
}
