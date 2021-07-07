import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/view/Lawyer/CaseInfoView.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewBidScreen extends StatefulWidget {
  @override
  _ViewBidScreenState createState() => _ViewBidScreenState();
}

class _ViewBidScreenState extends State<ViewBidScreen> {
  int userType = 0;

  @override
  initState() {
    SharedPreferences.getInstance().then((prefs) {
      var userInfoStr = prefs.getString(UserPrefernces.UserInfo);

      setState(() {
        var userInfo = json.decode(userInfoStr);
        userType = userInfo['userType'];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Bids',
            style: appThemeTextStyle(20,
                fontWeight: FontWeight.w600, textColor: Colors.black)),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset('images/Sidebar/ic_burger.svg')),
        ),
      ),
      drawer: SideBarView(),
      body: bidList(),
    );
  }

  Widget bidList() {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: ListView.builder(itemBuilder: (context, index) {
        // return CaseInfoView(userType);
      }),
    );
  }
}
