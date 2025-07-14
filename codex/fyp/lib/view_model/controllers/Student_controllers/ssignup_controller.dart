// Student Register Controller
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp/screens/student_screens/student_home.dart';
import 'package:fyp/utils/toastmessages.dart';
import 'package:fyp/view_model/controllers/Student_controllers/Ssession_controller.dart';

class SSignUpController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('student');

  bool _loading = false;
  bool get loading => _loading;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SSignUpController() {
    _initializeLocalNotifications();
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showWelcomeNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'welcome_channel',
      'Welcome Notifications',
      channelDescription: 'This channel is used for welcome notifications.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Welcome to StudyBuddy', // Notification Title
      'You have successfully registered!', // Notification Body
      platformDetails,
    );
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void Studentsignup(BuildContext context, username, String email,
      String password, String phoneno, String education, String city) {
    try {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SSessionController.session.userid = value.user!.uid.toString();
        ref.child(value.user!.uid.toString()).set({
          'uid': value.user!.uid.toString(),
          'name': username,
          'email': value.user!.email.toString(),
          'phone': phoneno,
          'education': education,
          'city': city,
          'onlinestatus': 'no one',
          'profile': '',
        }).then((value) {
          setLoading(false);

          // Show welcome notification
          _showWelcomeNotification();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StudentHome()));
        });
      }).onError((error, stackTrace) {
        setLoading(false);
        Messages.toastmessages(error.toString());
      });
    } catch (error) {
      Messages.toastmessages(error.toString());
    }
  }
}
