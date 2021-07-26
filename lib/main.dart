import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_lawyer/repository/Client/CountyRepository.dart';
import 'package:my_lawyer/repository/Client/StateRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/FCMService.dart';
import 'package:my_lawyer/view/Client/LawyerListScreen.dart';
import 'package:my_lawyer/view/LRF/SigninScreen.dart';
import 'package:my_lawyer/view/LRF/UserSelectionScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_lawyer/view/Lawyer/SearchCaseScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  FCMService().registerNotification();
  FCMService().getFCMToken();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString(UserPrefernces.UserToken);
  var isDoneSetup = prefs.getBool(UserPrefernces.DoneSetup);

  StateRepository().getStateList();
  CountyRepository().getCountryList();

  var userType = 0;
  if (token != null) {
    var userInfo = prefs.getString(UserPrefernces.UserInfo);
    userType = json.decode(userInfo)['userType'];
  }

  print('======= $token');
  runApp(MyApp(token: token, userType: userType, isDoneSetup: isDoneSetup));
}

class MyApp extends StatelessWidget {
  var token;
  var userType;
  var isDoneSetup;

  MyApp({this.token, this.userType, this.isDoneSetup});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: () => MaterialApp(
                navigatorKey: navigatorKey,
                title: 'Flutter Demo',
                home: (token == null)
                    ? UserSelectionScreen(isDoneSetup)
                    : (userType == UserType.Lawyer)
                        ? SearchCasesScreen()
                        : LawyerListScreen(LawyerListType.Hire),
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    primaryColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black)),
              ),
            );
  }
}
