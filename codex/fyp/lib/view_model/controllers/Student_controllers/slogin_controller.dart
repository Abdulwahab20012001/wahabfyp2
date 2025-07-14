// Student Login Controller
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp/screens/student_screens/student_home.dart';
import 'package:fyp/utils/toastmessages.dart';
import 'package:fyp/view_model/controllers/Student_controllers/Ssession_controller.dart';

class LLoginController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _loading = false;
  bool get loading => _loading;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LLoginController() {
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
      'We are glad to have you back!', // Notification Body
      platformDetails,
    );
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void studentLogin(BuildContext context, String email, String password) {
    try {
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        setLoading(false);
        SSessionController.session.userid = value.user!.uid.toString();

        // Show welcome notification
        _showWelcomeNotification();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StudentHome()));
      }).onError((error, stackTrace) {
        setLoading(false);
        Messages.toastmessages(error.toString());
      });
    } catch (e) {
      Messages.toastmessages(e.toString());
    }
  }
}
