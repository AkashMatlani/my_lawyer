import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_lawyer/generic_class/generic_button.dart';
import 'package:my_lawyer/generic_class/generic_textfield.dart';
import 'package:my_lawyer/utils/app_colors.dart';
import 'package:my_lawyer/utils/constant.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var txtEmail = TextEditingController();
  var txtPwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: signInView(),
    );
  }

  Widget signInView() {
    return Container(
      child: Column(
        children: [logoImg(), signInContainerView()],
      ),
    );
  }

  Widget logoImg() {
    return Image(
      image: AssetImage('images/LRF/ic_login_logo.png'),
      width: screenWidth(context),
      height: ScreenUtil().setHeight(246),
    );
  }

  Widget signInContainerView() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textSignIn(),
          txtFieldEmail(),
          txtFieldPwd(),
          forgotPwdBtn(),
          signInBtn()
        ],
      ),
    );
  }

  Widget textSignIn() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(23)),
      child: Text(
        'Sign In',
        style: appThemeTextStyle(28,
            textColor: Colors.black, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget txtFieldEmail() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(12), bottom: ScreenUtil().setHeight(12)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField(
            'Email ID', TextInputType.emailAddress, txtEmail,
            prefixIcon: 'images/LRF/ic_email.svg'),
      ),
    );
  }

  Widget txtFieldPwd() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(12)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField('Password', TextInputType.emailAddress, txtPwd,
            prefixIcon: 'images/LRF/ic_pwd.svg'),
      ),
    );
  }

  Widget forgotPwdBtn() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              textAlign: TextAlign.right,
              style: appThemeTextStyle(14, textColor: AppColor.ColorGray),
            ),
          )
        ],
      ),
    );
  }

  Widget signInBtn() {
    return SizedBox(
        width: screenWidth(context),
        height: ScreenUtil().setHeight(52),
        child: GenericButton().appThemeButton(
            'Sign In', 16, Colors.white, FontWeight.w700, () {

        }, borderRadius: 8));
  }
}
