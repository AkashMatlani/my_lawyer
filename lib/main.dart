import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lawyer/repository/Client/CountyRepository.dart';
import 'package:my_lawyer/repository/Client/StateRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/view/Client/LawyerListScreen.dart';
import 'package:my_lawyer/view/LRF/SigninScreen.dart';
import 'package:my_lawyer/view/LRF/UserSelectionScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_lawyer/view/Lawyer/SearchCaseScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // StateRepository().stateList();
  // CountyRepository().countyList();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString(UserPrefernces.UserToken);
  var isDoneSetup = prefs.getBool(UserPrefernces.DoneSetup);

  var userType = 0;
  if (token != null) {
    var userInfo = prefs.getString(UserPrefernces.UserInfo);
    userType = json.decode(userInfo)['userType'];
  }

  if (isDoneSetup == null) {
    isDoneSetup = false;
  }

  await Firebase.initializeApp();

  print('======= $token');
  runApp(MyApp(
    token: token,
    userType: userType,
      isDoneSetup: isDoneSetup
  ));
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
              title: 'Flutter Demo',
              home: (token == null)
                  ? UserSelectionScreen(isDoneSetup)
                  : (userType == UserType.Lawyer)
                      ? SearchCasesScreen()
                      : LawyerListScreen(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black)),
            ));
  }
}


// (token == null)
// ? (isDoneSetup == true) ? SignInScreen(0) : UserSelectionScreen()
//     : (userType == UserType.Lawyer)
// ? SearchCasesScreen()
//     : LawyerListScreen(),