import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/view/Client/EditProfileScreen.dart';
import 'package:my_lawyer/view/Client/ViewBidScreen.dart';
import 'package:my_lawyer/view/Lawyer/CaseDetailScreen.dart';
import 'package:my_lawyer/view/Lawyer/MyBidScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

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
    FirebaseMessaging.onMessage.listen((message) {
      print('onMessage');

      AlertView().showAlertView(
          navigatorKey.currentContext, message.notification.body, () {
        Navigator.pop(navigatorKey.currentContext);
      }, title: 'Notification', textColor: Colors.black);
    });

    FirebaseMessaging.onBackgroundMessage((message) {
      print('onBackgroundMessage');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp');

      print('Notification - ${message.notification.body}');
      print('Notification1 - ${message.notification.title}');
      String notificationType = message.data['type'];

      if (notificationType == NotificationType.SendProposal) {
        //Redirect on view bid
        Navigator.push(navigatorKey.currentContext,
            MaterialPageRoute(builder: (context) => ViewBidScreen()));
      } else if (notificationType == NotificationType.AcceptProposal) {
        //Redirect on case detail
        Navigator.push(
            navigatorKey.currentContext,
            MaterialPageRoute(
                builder: (context) => CaseDetailScreen(
                      caseId: int.parse(message.data['caseId']),
                      isFromMyCase: true,
                    )));
      }
      print('Remote Notification - $notificationType');
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("onBackgroundMessage: $message");
  }
}
