import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/components/sub_title.dart';
import 'package:weight_tracker/shared/theme_colors.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

Widget currentWeight(context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      customSubTitle('Current Weight', context),
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
              final userLatestTime = snapshot.data['weight']
                  [snapshot.data['weight'].length - 1]['time'];
              return Container(
                margin: symVerticalpx(10.0),
                height: screenHeight(context) * 0.15,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                          text: TextSpan(
                              text: userLatestWeight.toStringAsFixed(2),
                              style: trackerTheme(context).headline5.apply(
                                  color: Colors.white,
                                  fontWeightDelta: 2,
                                  fontSizeDelta: 1.5,
                                  fontSizeFactor: 2),
                              children: <TextSpan>[
                            TextSpan(
                              text: ' Kgs',
                              style: trackerTheme(context)
                                  .headline6
                                  .apply(color: Colors.white),
                            )
                          ])),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: symHorizontalpx(10.0),
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.white38,
                            ),
                          ),
                          Text(
                            userLatestTime,
                            style: trackerTheme(context)
                                .headline6
                                .apply(color: Colors.white38),
                          ),
                        ],
                      )
                    ],
                  ),
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
          })
    ],
  );
}
