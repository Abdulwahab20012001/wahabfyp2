import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
//import 'package:fyp/screens/student_screens/homescreen.dart';
import 'package:fyp/screens/Teacher_Screens/register&login_screens/teacher_login.dart';
import 'package:fyp/utils/toastmessages.dart';
//import 'package:provider/provider.dart';

class ForgetpasswordController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void Forgetpassword(
    BuildContext context,
    String email,
  ) {
    try {
      auth
          .sendPasswordResetEmail(
        email: email,
      )
          .then((value) {
        setLoading(false);

        Messages.toastmessages('Please check email to recover your password');
      }).onError((error, stackTrace) {
        setLoading(false);
        Messages.toastmessages(error.toString());
      }).onError((error, stackTrace) {
        setLoading(false);
        Messages.toastmessages(error.toString());
      });
    } catch (e) {
      Messages.toastmessages(e.toString());
    }
  }

  teacherlogin() {}
}
