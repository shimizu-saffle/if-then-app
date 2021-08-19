import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/main.dart';

final FcmProvider = ChangeNotifierProvider<FcmController>(
  (ref) => FcmController(),
);

class FcmController extends ChangeNotifier {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings? settings;

  setRequestPermission() async {
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return print('User granted permission: ${settings.authorizationStatus}');
  }

  iOSForegroundMessagesSettings() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  printToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  getSetToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    Future<void> saveTokenToDatabase(String token) async {
      // この例では、ユーザーがログインしていると仮定します。
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) //直接ドキュメント名を入れてみた(pokopoko@gmail.com)
          .update({
        'tokens': FieldValue.arrayUnion([token]),
      });
    }

    // 初期トークンのデータベースへの保存
    await saveTokenToDatabase(token!);

    // トークンが更新されるたびに、これもデータベースに保存します。
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  foregroundAndroidNotification() {
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });
    notifyListeners();
  }
}
