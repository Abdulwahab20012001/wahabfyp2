import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FirebaseMessagingHandler {
  FirebaseMessagingHandler._();

  static AndroidNotificationChannel channel_message =
      const AndroidNotificationChannel(
    "high_importance_channel",
    "High Importance Notifications",
    importance: Importance.high,
    enableLights: true,
    playSound: true,
  );

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> config() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    try {
      await messaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print("Received initial message: ${initialMessage.data}");
      }

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleNotificationTap(message);
      });

      var initializationSettingsAndroid =
          const AndroidInitializationSettings("@mipmap/ic_launcher");
      var darwinInitializationSettings = const DarwinInitializationSettings();

      LinuxInitializationSettings initializationSettingsLinux =
          const LinuxInitializationSettings(
              defaultActionName: 'Open notification');
      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        macOS: darwinInitializationSettings,
        iOS: darwinInitializationSettings,
        linux: initializationSettingsLinux,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
      );
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          print("Received foreground message: ${message.data}");
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel_message.id,
                channel_message.name,
                icon: android.smallIcon,
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
          );
        }
      });
    } on Exception catch (error) {
      print("Error initializing Firebase Messaging: $error");
    }
  }

  static Future<void> onDidReceiveLocalNotification(
      NotificationResponse notificationResponse) async {
    print("Local notification tapped: ${notificationResponse.payload}");
    // Handle local notification when the user taps on it.
    // Add navigation or other logic here if needed.
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackground(
      RemoteMessage? message) async {
    try {
      print("Handling background message: ${message?.data}");
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyA8_UOyJrCX_Z0XhcH_SHisP6QSaQxK9wU",
              appId: "1:147698689619:android:2cd47052e7d91c5f3888a6",
              messagingSenderId: "147698689619",
              projectId: "studybuddy-6ed40"));
      if (message != null) {
        // Handle background message
      }
    } catch (error) {
      print("Error handling background message: $error");
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    try {
      print("Notification tapped: ${message.messageId}");

      // Placeholder switch case - you can add your actual cases later
      switch (message.data["type"]) {
        default:
          print("No specific action defined for this notification type.");
          break;
      }
    } catch (error) {
      print("Error handling notification tap: $error");
    }
  }

  static Future<void> sendTopicMessage(
    String tokenOrTopic,
    Map<String, dynamic> notificationBody,
    Map<String, dynamic> dataBody,
  ) async {
    try {
      String serverToken = await getAccessToken();

      const String fcmUrl =
          'https://fcm.googleapis.com/v1/projects/"studybuddy-6ed40"/messages:send';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverToken',
      };

      final payload = PushNotificationService.constructFCMPayload(
          tokenOrTopic, notificationBody, dataBody);

      print("Sending FCM request with payload: $payload");

      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: headers,
        body: payload,
      );

      if (response.statusCode == 200) {
        print('FCM request sent successfully');
        print('Response body: ${response.body}');
      } else {
        print('FCM request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred while sending FCM request: $e');
    }
  }

  static Future<String> getAccessToken() async {
    try {
      // Load the JSON file from the assets
      final serviceAccountJson = await rootBundle.loadString(
          'lib/node_file/studybuddy-6ed40-firebase-adminsdk-3zdeq-15b5bebc7b.json');

      // Decode the JSON file
      final serviceAccount = json.decode(serviceAccountJson);

      // Create the credentials
      final accountCredentials =
          ServiceAccountCredentials.fromJson(serviceAccount);

      // Define the required scopes
      final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

      // Create an authenticated client using the service account credentials
      final authClient =
          await clientViaServiceAccount(accountCredentials, scopes);

      // Retrieve the access token
      final accessToken = authClient.credentials.accessToken;

      return accessToken.data;
    } catch (e) {
      // Add error handling and debugging output
      print("Error obtaining access token: $e");
      rethrow;
    }
  }
}

class PushNotificationService {
  static int _messageCount = 0;

  static String constructFCMPayload(
    String? tokenOrTopic,
    Map<String, dynamic> notificationBody,
    Map<String, dynamic> dataBody,
  ) {
    _messageCount++;

    // Adjust the payload for FCM HTTP v1 API
    Map<String, dynamic> payload = {
      "message": {
        if (tokenOrTopic != null && tokenOrTopic.startsWith('/topics/'))
          "topic": tokenOrTopic.replaceFirst('/topics/', ''),
        if (tokenOrTopic != null && !tokenOrTopic.startsWith('/topics/'))
          "token": tokenOrTopic,
        "notification": notificationBody,
        "data": dataBody,
        "android": {
          "priority": "high",
          "notification": {
            // "icon": "ic_launcher",
            "color": "#f45342",
          }
        },
        "apns": {
          "payload": {
            "aps": {
              "sound": "default",
              "badge": 1,
            }
          }
        }
      }
    };

    print("Constructed FCM payload: $payload");

    return jsonEncode(payload);
  }
}
