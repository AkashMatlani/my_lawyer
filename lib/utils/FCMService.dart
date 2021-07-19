import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMService {
  getFCMToken() async {
    FirebaseMessaging.instance.getToken().then((token) async {
      print('FCM Token - $token');

      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString(UserPrefernces.FCMToken, token);
    });
  }

  void registerNotification() async {
    //...On iOS, this helps to take the user permissions
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
    } else {
      print('User declined or has not accepted permission');
    }

    handleNotificationRedirection();
  }

  handleNotificationRedirection() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Remote Notification - $message');
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("onBackgroundMessage: $message");
  }
}
