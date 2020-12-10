import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/components/sub_title.dart';
import 'package:weight_tracker/database/database_model.dart';
import 'package:weight_tracker/shared/theme_colors.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

Widget bmiCalculator(context) {
  final DatabaseModel databaseModel = DatabaseModel();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      customSubTitle('BMI Calculator', context),
      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            } else if (snapshot.data['weight'].length > 0) {
              final userLatestWeight = double.parse(snapshot.data['weight']
                  [snapshot.data['weight'].length - 1]['weight']);
              final userHeight = double.parse(snapshot.data['height']) / 100;
              print(userHeight);
              final BMIIndex = userLatestWeight / pow(userHeight, 2);
              print(BMIIndex);
              return Container(
                margin: symVerticalpx(10.0),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10)),
                height: screenHeight(context) * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: allSymmetric(screenHeight(context) * 0.01, 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'BMI Index:',
                            style: trackerTheme(context)
                                .headline6
                                .apply(color: Colors.white),
                          ),
                          Padding(
                            padding: symHorizontalpx(20.0),
                            child: Text(
                              BMIIndex.toStringAsFixed(2),
                              style: trackerTheme(context).headline5.apply(
                                    color: Colors.white,
                                    fontWeightDelta: 2,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: symHorizontalpx(30.0),
                      child: Divider(
                        color: Colors.white38,
                      ),
                    ),
                    Text(
                      databaseModel.calculateBMIRange(BMIIndex),
                      style: trackerTheme(context).headline5.apply(
                            color: BMIIndex > 18.5 && BMIIndex < 25
                                ? Colors.green
                                : Colors.red,
                            fontWeightDelta: 2,
                          ),
                    )
                  ],
                ),
              );
            } else {
              return Padding(
                padding: symVerticalpx(10.0),
                child: Center(
                    child: Text(
                  'No Weights added',
                  style: trackerTheme(context)
                      .bodyText2
                      .apply(color: Colors.white38),
                )),
              );
            }
          }),
    ],
  );
}
