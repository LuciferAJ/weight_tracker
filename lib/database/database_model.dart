import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weight_tracker/model/user.dart';

class DatabaseModel {
  FirebaseAuth auth;

  Future<void> setUser(uid, email) {
    print("uploading User");
    return FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
    });
  }

  Future<void> uploadUserDetails(uid, details) {
    print("uploading user details");
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(details);
  }

  Future<DocumentSnapshot> getUserDetailsStatus(uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> updateWeight(uid, weightObject) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
      'weight': FieldValue.arrayUnion([weightObject])
    });
  }

  Stream<UserModel> userDetails(uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((event) {
      print(event.data());
      return UserModel.fromMap(event.data());
    });
  }

  String calculateBMIRange(BMIIndex) {
    if (BMIIndex < 16.0) {
      return 'Severe Thinness';
    } else if (BMIIndex >= 16 && BMIIndex <= 17) {
      return 'Moderate Thinness';
    } else if (BMIIndex > 17 && BMIIndex <= 18.5) {
      return 'Mild Thinness';
    } else if (BMIIndex > 18.5 && BMIIndex <= 25) {
      return 'Normal';
    } else if (BMIIndex >= 25 && BMIIndex <= 30) {
      return 'Overweight';
    } else if (BMIIndex > 30) {
      return 'Obese';
    } else {
      return '';
    }
  }
}
