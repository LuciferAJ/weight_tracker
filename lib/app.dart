import 'package:flutter/material.dart';
import 'package:weight_tracker/helper_functions.dart';
import 'package:weight_tracker/screens/authentication/sign_in.dart';
import 'package:weight_tracker/screens/authentication/sign_in_success.dart';
import 'package:weight_tracker/screens/homepage.dart';
import 'package:weight_tracker/screens/user_details_register.dart';
import 'package:weight_tracker/shared/theme_data.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn;
  bool isUserDetailsUploaded;

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedINSharedPreference().then((value) {
      setState(() {
        isUserLoggedIn = value;
      });
    });
  }

  getUserDetailsUploadedStatus() async {
    await HelperFunctions.getUserDetailsUploadedStatus().then((value) {
      setState(() {
        isUserDetailsUploaded = value;
      });
    });
  }

  @override
  void initState() {
    getLoggedInState();
    getUserDetailsUploadedStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weight Tracker',
        theme: weightTrackerTheme,
        home: isUserLoggedIn != null && isUserDetailsUploaded != null
            ? (isUserLoggedIn
                ? (isUserDetailsUploaded ? HomePage() : UserDetailsForm())
                : SignIn())
            : SignIn());
  }
}
