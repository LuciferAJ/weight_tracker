import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weight_tracker/components/authentication_screen_widgets/sign_in_image.dart';
import 'package:weight_tracker/components/customButton.dart';
import 'package:weight_tracker/components/sub_title.dart';
import 'package:weight_tracker/database/database_model.dart';
import 'package:weight_tracker/helper_functions.dart';
import 'package:weight_tracker/screens/authentication/sign_in_success.dart';
import 'package:weight_tracker/services/auth.dart';
import 'package:weight_tracker/shared/theme_colors.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String userEmail;
  String userPassword;
  bool emailAutoValidate = false;
  bool passWordAutoValidate = false;
  bool isSignInButtonPressed = false;
  final GlobalKey<State> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  DatabaseModel databaseModel = DatabaseModel();

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      setState(() {
        isSignInButtonPressed = true;
      });
      _auth
          .signInWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((value) {
        if (value != null) {
          databaseModel.getUserDetailsStatus(value.uid).then((snapshot) {
            if (snapshot.data() != null) {
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              Navigator.of(context)
                  .pushReplacement(
                      MaterialPageRoute(builder: (context) => SignInSuccess()))
                  .whenComplete(() => setState(() {
                        isSignInButtonPressed = false;
                      }));
            } else {
              databaseModel.setUser(value.uid, value.email).whenComplete(() {
                HelperFunctions.saveUserLoggedInSharedPreference(true);
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(
                        builder: (context) => SignInSuccess()))
                    .whenComplete(() => setState(() {
                          isSignInButtonPressed = false;
                        }));
              });
            }
          });
        } else {
          setState(() {
            isSignInButtonPressed = false;
          });
          Fluttertoast.showToast(
              msg: "Invalid Email or Password!!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 13.0);
        }
      });
    } else {
      print('Form is invalid');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isSignInButtonPressed
          ? Hero(
              tag: 'SignInButton',
              child: Container(
                height: screenHeight(context) * 0.08,
                width: screenWidth(context) * 0.2,
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(accentColor)),
                ),
              ),
            )
          : Container(
              margin: allSymmetric(20.0, screenWidth(context) * 0.2),
              child: customActionButton('SIGN IN', () {
                validateAndSave();
              }, context)),
      backgroundColor: primaryColor,
      body: Stack(
        children: <Widget>[
          ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              verticalSpace(screenHeight(context) * 0.1),
              CustomAnimatedLogo(),
              verticalSpace(screenHeight(context) * 0.08),
              signInDetails()
            ],
          ),
        ],
      ),
    );
  }

  Widget signInDetails() {
    return Container(
      margin: symHorizontalpx(40.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            customSubTitle('Sign In', context),
            verticalSpace(screenHeight(context) * 0.035),
            TextFormField(
              validator: (email) {
                if (RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(email)) {
                  return null;
                } else {
                  return 'Invalid Email address';
                }
              },
              onChanged: (email) {
                setState(() {
                  userEmail = email;
                  emailAutoValidate = true;
                });
              },
              autovalidate: emailAutoValidate,
              controller: _emailController,
              style: trackerTheme(context).subtitle1.apply(
                  color: Colors.white, fontSizeDelta: 1.2, fontSizeFactor: 1),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: trackerTheme(context).headline6.apply(
                    color: Colors.white,
                    fontSizeDelta: 0.8,
                    fontSizeFactor: 0.7),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                fillColor: secondaryColor,
                filled: true,
                focusColor: accentColor,
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
              cursorColor: accentColor,
            ),
            verticalSpace(screenHeight(context) * 0.02),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  passWordAutoValidate = true;
                });
              },
              autovalidate: passWordAutoValidate,
              validator: (password) {
                if (password.length < 2) {
                  return 'Incorrect Password';
                } else {
                  return null;
                }
              },
              controller: _passwordController,
              obscureText: true,
              style: trackerTheme(context).subtitle1.apply(
                  color: Colors.white, fontSizeDelta: 1.2, fontSizeFactor: 1),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: trackerTheme(context).headline6.apply(
                    color: Colors.white,
                    fontSizeDelta: 0.8,
                    fontSizeFactor: 0.7),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                fillColor: secondaryColor,
                filled: true,
                focusColor: accentColor,
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
              cursorColor: accentColor,
            )
          ],
        ),
      ),
    );
  }
}
