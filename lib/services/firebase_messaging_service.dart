import 'dart:core';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:alhalaqat/app/home/approved/common_screens/conversation/chat/chat_screen.dart';
import 'package:alhalaqat/app/models/conversation.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:alhalaqat/services/local_storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMessagingService {
  FirebaseMessagingService({
    @required this.navigatorKey,
    @required this.context,
  });
  final GlobalKey<NavigatorState> navigatorKey;
  final BuildContext context;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void configLocalNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          // this is for iphone usings ios under 10

          // didReceiveLocalNotificationSubject.add(ReceivedNotification(
          //     id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (dynamic payload) async {
      if (payload != null) {
        //! clicking on the notif callback
        print('onMessage Clicked: ');
        print(payload);
      }
    });
  }

  Future<void> configFirebaseNotification(String uid, Database database) async {
    //print('configuring FIREBASE MESSAGING');
    configLocalNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print("onMessage: $message");

        showNotification(message.notification);
      }
    });

    // _firebaseMessaging
    //     .requestNotificationPermissions(const IosNotificationSettings(
    //   sound: true,
    //   badge: true,
    //   alert: true,
    //   provisional: true,
    // ));

    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _firebaseMessaging.getToken().then((String newToken) async {
      print('************user token*************');
      print(newToken);
      SharedPreferences perfs = await SharedPreferences.getInstance();
      LocalStorageService storageService = LocalStorageService(perfs: perfs);
      String oldToken = storageService.getValue('pushToken');
      //oldToken != newToken
      if (true) {
        database.setData(
          path: APIPath.userDocument(uid),
          data: {'pushToken': newToken},
          merge: true,
        );
        storageService.addValue(MapEntry('pushToken', newToken));
      }
    });
  }

  Future<void> showNotification(RemoteNotification message) async {
    int id = Random().nextInt(1000);
    print('showing notification called*****************');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid ? 'com.kwexpress.app' : 'com.kwexpress.app.ios2',
      'KW express',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      message.title,
      message.body,
      platformChannelSpecifics,
    );
  }

  Future<void> takeToChatScreen(Map<String, dynamic> message) async {
    print(message.runtimeType);
    Map<String, dynamic> t =
        Map.castFrom<dynamic, dynamic, String, dynamic>(message);
    print('+++++++++++++++' + t.runtimeType.toString());
    Conversation conversation = Conversation.fromNotificationData(t);

    if (conversation != null) {
      await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) =>
              ChatScreen.create(context: context, conversation: conversation),
          fullscreenDialog: true,
        ),
      );
    }
  }
}
