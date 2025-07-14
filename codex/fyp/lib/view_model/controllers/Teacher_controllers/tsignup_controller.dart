// SignUpController.dart
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_homescreen.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tsession_controller.dart';

class SignUpController with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseReference ref =
      FirebaseDatabase.instance.ref().child('teacher');
  bool _isLoading = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SignUpController() {
    _initializeLocalNotifications();
  }

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showWelcomeNotification() async {
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

  Future<bool> signup(
    BuildContext context,
    String name,
    String email,
    String password,
    String phone,
    String education,
    String city,
    String stripeId,
    File certificateImage,
  ) async {
    try {
      setLoading(true);

      // Create user with FirebaseAuth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Upload certificate image to Firebase Storage
      String certificateUrl = '';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('certificates/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(certificateImage);
      certificateUrl = await storageRef.getDownloadURL();

      // Store teacher data in Firebase Realtime Database
      await ref.child(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': userCredential.user!.email,
        'phone': phone,
        'education': education,
        'city': city,
        'stripeId': stripeId,
        'certificateUrl': certificateUrl,
        'profile': '', // Empty profile image initially
      });

      // Set the session user ID
      SessionController.session.userid = userCredential.user!.uid;

      // Navigate to Teacher Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const home()),
      );

      // Show welcome notification
      await showWelcomeNotification();

      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      return false;
    }
  }
}
