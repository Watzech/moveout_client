// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:moveout1/services/device_info.dart';
import 'package:moveout1/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message on _firebaseMessagingBackgroundHandler: ${message.messageId}");
  await requestSave();
}

void prepareDeviceForNotification(BuildContext context) async {

  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("message recieved on prepareDeviceForNotification");
    print(event.notification!.body);
    if (event.notification != null) {
      print('Message also contained a notification: ${event.notification}');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved on prepareDeviceForNotification showing dialog");
      print(event.notification!.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Notification"),
            content: Text(event.notification!.body!),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
    });
}

void getNotification() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  late FirebaseMessaging token;

  token = FirebaseMessaging.instance;
  token.getToken().then((value) async {
    print(value);
    await saveNotificationToken(value);
  });

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

}