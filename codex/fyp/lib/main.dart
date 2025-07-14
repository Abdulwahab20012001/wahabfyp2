import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fyp/screens/Other_screens/splash_screen.dart';
import 'package:fyp/utils/Firebase_Msg_Handler.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tsignup_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Set your Stripe publishable key
    Stripe.publishableKey =
        'pk_test_51Q5RAIA40ev6IKjQIqC79etTkmrCSDTBxdxF2vbsnaJXxZuhbEo69kzndvHExVUoe3JSGkeWuK9AV7U4tq8prI2U005Z4zQiDr';

    // Apply Stripe settings (optional)
    await Stripe.instance.applySettings();
  } catch (e) {
    // Handle any initialization errors (optional)
    print("Error during initialization: $e");
  }
  firebaseChatInit().then((value) {
    FirebaseMessagingHandler.config();
  });
  runApp(const MyApp());
}

Future firebaseChatInit() async {
  FirebaseMessaging.onBackgroundMessage(
      FirebaseMessagingHandler.firebaseMessagingBackground);
  if (Platform.isAndroid) {
    await FirebaseMessagingHandler.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(FirebaseMessagingHandler.channel_message);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (_) =>
                    SignUpController()), // Add SignUpController provider
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Study Buddy',
            theme: ThemeData(
              primaryColor: Colors.white,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home:
                const SplashScreen(), // Keep the SplashScreen as the home screen
          ),
        );
      },
    );
  }
}

/*
Container(
                height: 350,
                width: 250,
                child: AnotherCarousel(
                  images: const [
                    AssetImage("assets/e8.png"),
                    AssetImage("assets/uiu.png"),
                    AssetImage("assets/e0011.png"),
                  ],
                  dotSize: 4.0,
                  dotSpacing: 15.0,
                  dotColor: Colors.lightGreenAccent,
                  indicatorBgPadding: 5.0,
                  dotBgColor: Color.fromARGB(255, 48, 46, 46).withOpacity(0.5),
                  borderRadius: true,
                ),
              ),
*/
