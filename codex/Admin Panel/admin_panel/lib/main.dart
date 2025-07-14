import 'package:admin_panel/Admin_Dashboard.dart';
import 'package:admin_panel/login.dart';
import 'package:admin_panel/login_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AlzaSyA8_UOyJrCX_Z0XhcH_SHisP6QSaQxK9wU",
          authDomain: "studybuddy-6ed40.firebaseapp.com",
          databaseURL: "https://studybuddy-6ed40-default-rtdb.firebaseio.com",
          projectId: "studybuddy-6ed40",
          storageBucket: "studybuddy-6ed40.appspot.com",
          messagingSenderId: "147698689619",
          appId: "1:147698689619:android:2cd47052e7d91c5f3888a6",
          measurementId: "your-measurement-id" // Optional, if available
          ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthCheck(), // Use a new widget for checking auth status
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future:
          Provider.of<AuthProvider>(context, listen: false).checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else {
          // If the user is logged in, show the dashboard, otherwise show the login screen
          return snapshot.data == true ? AdminDashboard() : AdminLoginScreen();
        }
      },
    );
  }
}
