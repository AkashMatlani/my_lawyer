import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lawyer/view/LRF/UserSelectionScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: () => MaterialApp(
              title: 'Flutter Demo',
              home: UserSelectionScreen(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black)),
            ));
  }
}
