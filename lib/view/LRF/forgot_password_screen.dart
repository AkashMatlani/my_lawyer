import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_lawyer/generic_class/generic_button.dart';
import 'package:my_lawyer/generic_class/generic_textfield.dart';
import 'package:my_lawyer/utils/constant.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var txtEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password', style: appThemeTextStyle(20, fontWeight: FontWeight.w600, textColor: Colors.black),),
        // backgroundColor: Colors.white,
      ),
      body: forgotPasswordView(),
    );
  }

  Widget forgotPasswordView() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [txtFieldEmail(), submitBtn()],
        ),
      ),
    );
  }

  Widget txtFieldEmail() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(24), bottom: ScreenUtil().setHeight(24)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField(
            'Email ID', TextInputType.emailAddress, txtEmailController,
            prefixIcon: 'images/LRF/ic_email.svg'),
      ),
    );
  }

  Widget submitBtn() {
    return SizedBox(
        width: screenWidth(context),
        height: ScreenUtil().setHeight(52),
        child: GenericButton().appThemeButton(
            'Submit', 16, Colors.white, FontWeight.w700, () {},
            borderRadius: 8));
  }
}
