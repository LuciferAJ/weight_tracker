import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight_tracker/components/customButton.dart';
import 'package:weight_tracker/components/sub_title.dart';
import 'package:weight_tracker/database/database_model.dart';
import 'package:weight_tracker/helper_functions.dart';
import 'package:weight_tracker/screens/homepage.dart';
import 'package:weight_tracker/shared/theme_colors.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

class UserDetailsForm extends StatefulWidget {
  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final GlobalKey<State> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  bool heightAutoValidate = false;
  bool weightAutoValidate = false;
  bool nameAutoValidate = false;
  bool isSubmitButtonPressed = false;
  DatabaseModel databaseModel = DatabaseModel();

  validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      setState(() {
        isSubmitButtonPressed = true;
      });
      Map<String, dynamic> details = {
        'name': _nameController.text,
        'height': _heightController.text,
        'weight': _weightController.text
      };
      databaseModel
          .uploadUserDetails(FirebaseAuth.instance.currentUser.uid, details)
          .whenComplete(() {
        HelperFunctions.userDetailsUploaded(true);
        Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()))
            .whenComplete(() {
          setState(() {
            isSubmitButtonPressed = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isSubmitButtonPressed
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
              child: customActionButton('Submit', () {
                validateAndSave();
              }, context)),
      backgroundColor: primaryColor,
      body: userDetailsFormBody(),
    );
  }

  Widget userDetailsFormBody() {
    return Container(
      margin: symHorizontalpx(40.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            customSubTitle('Enter your details', context),
            verticalSpace(screenHeight(context) * 0.035),
            TextFormField(
              autovalidate: nameAutoValidate,
              validator: (name) {
                if (name.length < 2) {
                  return 'Enter your Name';
                } else {
                  return null;
                }
              },
              onChanged: (name) {
                if (name.toString().length > 0) {
                  setState(() {
                    nameAutoValidate = true;
                  });
                } else {
                  setState(() {
                    nameAutoValidate = false;
                  });
                }
              },
              controller: _nameController,
              style: trackerTheme(context).subtitle1.apply(
                  color: Colors.white, fontSizeDelta: 1.2, fontSizeFactor: 1),
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp('[a-zA-Z0-9]')),
              ],
              decoration: InputDecoration(
                labelText: 'Name',
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
            verticalSpace(20),
            TextFormField(
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp('[0-9]'))
              ],
              maxLength: 3,
              autovalidate: heightAutoValidate,
              validator: (height) {
                if (height.toString().trim().isEmpty) {
                  return 'Enter valid height';
                } else {
                  return null;
                }
              },
              onChanged: (height) {
                if (height.toString().length > 0) {
                  setState(() {
                    heightAutoValidate = true;
                  });
                } else {
                  setState(() {
                    heightAutoValidate = false;
                  });
                }
              },
              keyboardType: TextInputType.number,
              controller: _heightController,
              style: trackerTheme(context).subtitle1.apply(
                  color: Colors.white, fontSizeDelta: 1.2, fontSizeFactor: 1),
              decoration: InputDecoration(
                  labelText: 'Height (in cm.)',
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
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  counterText: ''),
              cursorColor: accentColor,
            ),
            verticalSpace(20),
            TextFormField(
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp('[0-9]'))
              ],
              maxLength: 3,
              keyboardType: TextInputType.number,
              autovalidate: weightAutoValidate,
              validator: (weight) {
                if (weight.toString().trim().isEmpty) {
                  return 'Enter valid Weight';
                } else {
                  return null;
                }
              },
              onChanged: (weight) {
                if (weight.toString().length > 0) {
                  setState(() {
                    weightAutoValidate = true;
                  });
                } else {
                  setState(() {
                    weightAutoValidate = false;
                  });
                }
              },
              controller: _weightController,
              style: trackerTheme(context).subtitle1.apply(
                  color: Colors.white, fontSizeDelta: 1.2, fontSizeFactor: 1),
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Weight (in 1-399 kgs.)',
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
