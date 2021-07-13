import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      var userInfoStr = prefs.getString(UserPrefernces.UserInfo);

      setState(() {
        userInfo = json.decode(userInfoStr);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information',
            style: appThemeTextStyle(20,
                fontWeight: FontWeight.w600, textColor: Colors.black)),
      ),
      body: paymentView(),
    );
  }

  Widget paymentView() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20),
            top: ScreenUtil().setHeight(20),
            bottom: ScreenUtil().setHeight(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            txtTitleView('First Name'),
            txtSubTitleView(),
            txtTitleView('Last Name'),
            txtSubTitleView(),
            txtTitleView('Email'),
            Row(
              children: [
                SvgPicture.asset(
                  'images/LRF/ic_email.svg',
                  width: ScreenUtil().setWidth(15),
                  height: ScreenUtil().setHeight(12),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    userInfo['email'],
                    style: appThemeTextStyle(15,
                        fontWeight: FontWeight.w700, textColor: Colors.black),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(20),
                  bottom: ScreenUtil().setHeight(16)),
            ),
            Text('Payment Information'),
            Row(
              children: [
                Container(
                    width: ScreenUtil().setWidth(66),
                    height: ScreenUtil().setHeight(41),
                    color: Colors.red,
                    child: InkWell(
                      onTap: () {
                        
                      },
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget txtTitleView(String title) {
    return Text(
      title,
      style: appThemeTextStyle(14,
          fontWeight: FontWeight.w600,
          textColor: Color.fromRGBO(104, 104, 104, 1)),
    );
  }

  Widget txtSubTitleView() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(12)),
      child: Text(
        userInfo['userName'],
        style: appThemeTextStyle(15,
            fontWeight: FontWeight.w700, textColor: Colors.black),
      ),
    );
  }
}