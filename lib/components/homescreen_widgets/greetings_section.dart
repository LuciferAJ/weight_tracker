import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/app.dart';
import 'package:weight_tracker/helper_functions.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

Widget greetings(context) {
  String userName;
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        } else {
          userName = snapshot.data['name'];
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Welcome,",
                        style: trackerTheme(context)
                            .subtitle1
                            .apply(color: Colors.white38)),
                    GestureDetector(
                        child: Icon(
                          Icons.exit_to_app,
                          color: Colors.white38,
                        ),
                        onTap: () {
                          HelperFunctions.saveUserLoggedInSharedPreference(
                              false);
                          FirebaseAuth.instance.signOut().whenComplete(() =>
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                  (route) => false));
                        })
                  ],
                ),
                Text(
                  userName ?? '',
                  style: trackerTheme(context)
                      .headline5
                      .apply(color: Colors.white, fontWeightDelta: 2),
                )
              ],
            ),
          );
        }
      });
}
