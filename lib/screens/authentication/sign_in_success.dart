import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/database/database_model.dart';
import 'package:weight_tracker/helper_functions.dart';
import 'package:weight_tracker/screens/homepage.dart';
import 'package:weight_tracker/screens/user_details_register.dart';
import 'package:weight_tracker/services/auth.dart';
import 'package:weight_tracker/shared/theme_colors.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

class SignInSuccess extends StatefulWidget {
  @override
  _SignInSuccessState createState() => _SignInSuccessState();
}

class _SignInSuccessState extends State<SignInSuccess> {
  DatabaseModel databaseModel = DatabaseModel();
  Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      databaseModel
          .getUserDetailsStatus(FirebaseAuth.instance.currentUser.uid)
          .then((value) {
        if (value.data()['name'] != null) {
          HelperFunctions.userDetailsUploaded(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => UserDetailsForm()));
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
              tag: 'SignInButton',
              child: Icon(
                Icons.check_circle,
                color: accentColor,
                size: 80,
              )),
          verticalSpace(20),
          Text(
            'Successfully Signed-In',
            style: trackerTheme(context).headline6.apply(color: Colors.white),
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}
