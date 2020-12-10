import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight_tracker/components/customButton.dart';
import 'package:weight_tracker/components/homescreen_widgets/body.dart';
import 'package:weight_tracker/database/database_model.dart';
import 'package:weight_tracker/shared/theme_colors.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FixedExtentScrollController _kgController = FixedExtentScrollController();
  FixedExtentScrollController _gmController = FixedExtentScrollController();
  DatabaseModel databaseModel = DatabaseModel();
  int latestKgs;
  int latestGms;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _kgController.dispose();
    _gmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: homepageBody(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: customActionButton('NEW WEIGHT', () {
        showModalBottomSheet(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40))),
            context: context,
            builder: (context) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .get()
                  .then((value) {
                setState(() {
                  latestKgs = double.parse(value['weight']
                              [value['weight'].length - 1]['weight']
                          .toString())
                      .toInt();
                  latestGms = int.tryParse(value['weight']
                          [value['weight'].length - 1]['weight']
                      .toString()
                      .split('.')[1]);
                });
              });

              print('latestKgs' + latestKgs.toString());
              print('latestKgs' + latestGms.toString());
              _kgController.animateToItem(latestKgs,
                  duration: Duration(milliseconds: 2), curve: Curves.elasticIn);
              _gmController.animateToItem(latestGms,
                  duration: Duration(milliseconds: 2), curve: Curves.elasticIn);
              return bottomSheetContent();
            });
      }, context),
    );
  }

  Widget bottomSheetContent() {
    return Container(
      height: screenHeight(context) * 0.45,
      child: Padding(
        padding: symHorizontalpx(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Padding(
                  padding: symVerticalpx(10.0),
                  child: Container(
                    height: 5,
                    width: screenWidth(context) * 0.35,
                    decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(20)),
                  )),
            ),
            Row(
              children: <Widget>[
                Text(
                  'New Weight',
                  style: trackerTheme(context)
                      .headline6
                      .apply(color: Colors.white, fontWeightDelta: 2),
                ),
                Spacer(),
                CloseButton(
                  color: Colors.white38,
                )
              ],
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: screenHeight(context) * 0.24,
                    width: screenWidth(context) * 0.17,
                    child: CupertinoPicker(
                      scrollController: _kgController,
                      itemExtent: 30,
                      magnification: 1.6,
                      children: List.generate(
                          400,
                          (index) => Text(
                                index < 10
                                    ? ('0' + index.toString())
                                    : index.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                      useMagnifier: true,
                      squeeze: 1,
                      onSelectedItemChanged: (int index) {
                        HapticFeedback.mediumImpact();
                      },
                    ),
                  ),
                  Text(
                    'Kg',
                    style: trackerTheme(context)
                        .caption
                        .apply(color: Colors.white),
                  ),
                  Container(
                    height: screenHeight(context) * 0.24,
                    width: screenWidth(context) * 0.16,
                    child: CupertinoPicker(
                      scrollController: _gmController,
                      itemExtent: 30,
                      magnification: 1.6,
                      children: List.generate(
                        100,
                        (index) => Text(
                          index < 10
                              ? ('0' + index.toString())
                              : index.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      useMagnifier: true,
                      squeeze: 1,
                      onSelectedItemChanged: (int index) {
                        HapticFeedback
                            .mediumImpact(); //gives haptic feedback on physical devices
                      },
                    ),
                  ),
                  Text(
                    'gm',
                    style: trackerTheme(context)
                        .caption
                        .apply(color: Colors.white),
                  )
                ],
              ),
            ),
            verticalSpace(20),
            Center(
                child: customActionButton('SAVE', () {
              print(_kgController.selectedItem);
              var date = DateTime.parse(DateTime.now().toString());
              print(date);

              //To get the formatted date
              var formattedDate = "${date.day}-${date.month}-${date.year}";
              print(formattedDate);

              //weightObject for sending to firestore
              final weightObject = {
                'weight': _kgController.selectedItem.toString() +
                    '.' +
                    _gmController.selectedItem.toString(),
                'time': formattedDate
              };
              databaseModel
                  .updateWeight(
                      FirebaseAuth.instance.currentUser.uid, weightObject)
                  .whenComplete(() => Navigator.of(context).pop());
            }, context))
          ],
        ),
      ),
    );
  }
}
