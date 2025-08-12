import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_connect2/main.dart'; 

class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // static void firebaseInit() {
  //   FirebaseMessaging.onMessage.listen((message){
  //     print(message.notification!.title);
  //     print(message.notification!.body);
  //   });
  // }

// Request permission for notification
  void requestPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('Permission granted');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('Permission granted provisionally');
  }else{
    AppSettings.openAppSettings(type: AppSettingsType.notification);
    print('Permission denied');
  }
}

// Get the device token
Future<String> getDeviceToken() async{
  String? token = await messaging.getToken();
  return token!;
}

void isTokenRefresh() async{
  messaging.onTokenRefresh.listen((event){
    event.toString();
  });
}

// initialize the notification
void initLocalNotification(BuildContext context, RemoteMessage message) async{
  var androidInitSetting = 
       AndroidInitializationSettings('@mipmap/ic_launcher');
       var iosInitSetting = const DarwinInitializationSettings();

  var initializeSetting = InitializationSettings(
    android: androidInitSetting,
    iOS: iosInitSetting,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializeSetting,
    onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    },
  );
}

// firebase Init (if app is on)
void firebaseInit(BuildContext context){
  FirebaseMessaging.onMessage.listen((message){
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification!.android;

    if(kDebugMode){
      print('notification title: ${notification!.title}');
      print('notification body: ${notification.body}');
    }

    // for ios
    if(Platform.isIOS){
      iosForegroundMessage();
    }

    // for android
    if(Platform.isAndroid){
      initLocalNotification(context, message);
      // handleMessage(context, message);
      showNotification(message);
    }
  });
}

// function show notification
Future<void> showNotification(RemoteMessage message) async{
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    message.notification!.android!.channelId.toString(),
    message.notification!.android!.channelId.toString(),
    importance: Importance.high,
    showBadge: true,
    playSound: true,
);

AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
channel.id.toString(),
channel.name.toString(),
channelDescription: "chanel Description",
priority: Priority.high,
playSound: true,
sound: channel.sound,
);
// ios settings
DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
);
// merge settings
NotificationDetails notificationDetails = NotificationDetails(
  android: androidNotificationDetails,
  iOS: darwinNotificationDetails,
);

// show notification
Future.delayed(Duration.zero,(){
  flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title.toString(),
    message.notification!.body.toString(),
    notificationDetails,
    payload: message.data.toString(),
  );
});
}

// background and terminated app state
Future<void> setupInteractMessage(BuildContext context) async{
  // background state
  FirebaseMessaging.onMessageOpenedApp.listen((event){
    handleMessage(context, event);
  });

  // terminated state
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
    if(message != null && message.data.isNotEmpty){
      handleMessage(context, message);
    }
  });
}

// handle message
Future<void> handleMessage(BuildContext context, RemoteMessage message) async{
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
}

// ios message
Future iosForegroundMessage() async{
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

}

