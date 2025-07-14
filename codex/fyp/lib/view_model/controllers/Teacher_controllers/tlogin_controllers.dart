import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Local Notifications
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_homescreen.dart';
import 'package:fyp/utils/toastmessages.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tsession_controller.dart';

class LoginController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Local Notifications instance

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  LoginController() {
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

  Future<void> login(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Sign in with email and password
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Get the FCM Token after successful login
      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");

      if (token != null) {
        // Save the token in the teacher node
        DatabaseReference userRef =
            _database.ref().child("teacher").child(userCredential.user!.uid);
        await userRef.update({
          'fcm_token': token,
          'last_login': ServerValue.timestamp,
        }).then((_) {
          print("FCM Token saved to teacher node in Realtime Database.");
        }).catchError((error) {
          print("Error saving FCM Token: $error");
        });
      }

      // Show welcome notification
      await _showWelcomeNotification();

      // Store user session
      SessionController.session.userid = userCredential.user!.uid.toString();

      // Navigate to home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Messages.toastmessages('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Messages.toastmessages('Wrong password provided for that user.');
      } else {
        Messages.toastmessages(e.message ?? 'An error occurred.');
      }
    } catch (e) {
      Messages.toastmessages('An error occurred. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
