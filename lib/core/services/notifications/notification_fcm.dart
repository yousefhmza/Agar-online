import 'package:agar_online/config/routing/navigation_service.dart';
import 'package:agar_online/config/routing/routes.dart';
import 'package:agar_online/core/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsFCM {
  NotificationsFCM() {
    configLocalNotification();
    registerNotification();
    _createNotificationChannel("agarOnline", "agarOnline", "agarOnline");
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  configLocalNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void registerNotification() async {
    try {
      await firebaseMessaging.requestPermission();

      // Foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final RemoteNotification? notification = message.notification;
        final Map<String, dynamic> data = message.data;
        if (notification == null) showNotification('${data["title"]}', data["body"]);
        if (notification != null) showNotification('${notification.title}', '${notification.body}');
      });

      // Background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessage(message);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    firebaseMessaging.subscribeToTopic("agarOnline");
    // firebaseMessaging.getToken().then((token) {
    //   saveFCM(token!);
    // });
  }

  static Future<void> handleNotificationsFromTermination() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) _handleMessage(initialMessage);
  }

  static void _handleMessage(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      switch (message.data["screen"]) {
        case "adscreen":
          NavigationService.push(
            globalContext,
            Routes.adDetailsScreen,
            arguments: {"id": int.parse(message.data["property_id"].toString())},
          );
          break;
      }
    }
  }

  Future<void> _createNotificationChannel(String id, String name, String description) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidNotificationChannel = AndroidNotificationChannel(id, name);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  void showNotification(title, message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'agarOnline',
      'agarOnline',
      playSound: true,
      enableVibration: false,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      1,
      '$title',
      '$message',
      platformChannelSpecifics,
    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    _handleMessage(message);
  }

  static Future<String?> getToken() async => await FirebaseMessaging.instance.getToken();

  void saveFCM(String fcm) async {
    // networkSendFcm(fcm);
  }
}
