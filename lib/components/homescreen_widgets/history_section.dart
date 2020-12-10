import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/database/database_model.dart';
import 'package:weight_tracker/screens/weight_history.dart';
import 'package:weight_tracker/shared/theme_colors.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';
import '../sub_title.dart';

class WeightHistorySection extends StatefulWidget {
  @override
  _WeightHistorySectionState createState() => _WeightHistorySectionState();
}

class _WeightHistorySectionState extends State<WeightHistorySection> {
  DatabaseModel databaseModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            customSubTitle('History', context),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WeightHistory()));
              },
              child: Text(
                'See All',
                style: trackerTheme(context).caption.apply(color: accentColor),
              ),
            ),
          ],
        ),
        Container(
            margin: symVerticalpx(10.0),
            child: StreamBuilder(
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
                            itemCount:
                                weightList.length < 5 ? weightList.length : 5,
                            itemBuilder: (context, index) =>
                                weightsTiles(context, weightList, index, true))
                        : Center(
                            child: Text(
                            'No History available',
                            style: trackerTheme(context)
                                .bodyText2
                                .apply(color: Colors.white38),
                          ));
                  }
                }))
      ],
    );
  }
}

Widget weightsTiles(context, weightLists, index, isHomePage) {
  print(weightLists.length);
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: secondaryColor, borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      dense: true,
      contentPadding: allSymmetric(0.0, 20.0),
      title: Text(
        weightLists[(weightLists.length - 1) - index]['time'] ?? '',
        style: trackerTheme(context).caption.apply(
            color: Colors.white38, fontSizeDelta: 0.1, fontSizeFactor: 1),
      ),
      subtitle: (weightLists.length - (index + 1)) > 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (double.parse(weightLists[(weightLists.length - index - 1)]
                                ['weight']) -
                            double.parse(
                                weightLists[(weightLists.length - index - 2)]
                                    ['weight'])) >
                        0
                    ? Icon(Icons.arrow_drop_up, color: Colors.red, size: 24)
                    : Icon(Icons.arrow_drop_down,
                        color: Colors.green, size: 24),
                Text(
                  (double.parse(weightLists[(weightLists.length - index - 1)]
                                  ['weight']) -
                              double.parse(
                                  weightLists[(weightLists.length - index - 2)]
                                      ['weight']))
                          .abs()
                          .toStringAsFixed(2)
                          .toString() +
                      "kg",
                  style: trackerTheme(context).bodyText1.apply(
                      fontSizeDelta: 1,
                      color: (double.parse(weightLists[(weightLists.length -
                                      index -
                                      1)]['weight']) -
                                  double.parse(weightLists[(weightLists.length -
                                      index -
                                      2)]['weight'])) >
                              0
                          ? Colors.red
                          : Colors.green),
                ),
              ],
            )
          : Text(
              ' - - ',
              style: TextStyle(color: Colors.white),
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RichText(
              text: TextSpan(
                  text: weightLists[(weightLists.length - 1) - index]
                              ['weight'] !=
                          null
                      ? weightLists[weightLists.length - index - 1]['weight']
                          .toString()
                      : '',
                  style: trackerTheme(context)
                      .headline6
                      .apply(fontWeightDelta: 2, color: Colors.white),
                  children: <TextSpan>[
                TextSpan(
                  text: ' kg',
                  style:
                      trackerTheme(context).caption.apply(color: Colors.white),
                )
              ])),
          !isHomePage
              ? GestureDetector(
                  onTap: () {
                    //  Have to implement edit functionality
                  },
                  child: Padding(
                    padding: symHorizontalpx(8.0),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white38,
                    ),
                  ),
                )
              : Container(),
          !isHomePage
              ? GestureDetector(
                  onTap: () {
                    //  Have to implement delete functionality
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.white38,
                  ))
              : Container(),
        ],
      ),
    ),
  );
}
