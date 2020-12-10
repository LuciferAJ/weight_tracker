import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/components/homescreen_widgets/history_section.dart';
import 'package:weight_tracker/shared/theme_colors.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

class WeightHistory extends StatefulWidget {
  @override
  _WeightHistoryState createState() => _WeightHistoryState();
}

class _WeightHistoryState extends State<WeightHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text('Weight History'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            } else {
              List weightList = snapshot.data['weight'];
              return weightList.length > 0
                  ? ListView.builder(
                      padding: allCustompx(0.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: weightList.length,
                      itemBuilder: (context, index) =>
                          weightsTiles(context, weightList, index, false))
                  : Center(
                      child: Text(
                      'No History available',
                      style: trackerTheme(context)
                          .bodyText2
                          .apply(color: Colors.white38),
                    ));
            }
          }),
    );
  }
}
