import 'dart:ui';

import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_lawyer/generic_class/generic_button.dart';
import 'package:my_lawyer/generic_class/generic_textfield.dart';
import 'package:my_lawyer/utils/app_colors.dart';
import 'package:my_lawyer/utils/constant.dart';
import 'package:my_lawyer/view/LRF/forgot_password_screen.dart';
import 'package:my_lawyer/view/LRF/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  int userType;

  SignInScreen(this.userType);

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
      fit: BoxFit.fill,
      // )
    );
  }

  Widget signInContainerView() {
    return Expanded(
        flex: 1,
        child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Form(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                    // logoImg(),
                    textSignIn(),
                    txtFieldEmail(),
                    txtFieldPwd(),
                    forgotPwdBtn(),
                    signInBtn(),
                    txtOrConnectWith(),
                    googleSignInBtn(),
                    txtDontHaveAccount()
                  ],
                ),
              ),
            )));
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
            prefixIcon: 'images/LRF/ic_email.svg', hasPrefixIcon: true),
      ),
    );
  }

  Widget txtFieldPwd() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField('Password', TextInputType.emailAddress, txtPwd,
            prefixIcon: 'images/LRF/ic_pwd.svg', obscureText: true, hasPrefixIcon: true),
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
            onPressed: () {
              _pressedOnForgotPassword();
            },
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
            'Sign In', 16, Colors.white, FontWeight.w700, () {},
            borderRadius: 8));
  }

  Widget txtOrConnectWith() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(35), bottom: ScreenUtil().setHeight(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FDottedLine(
            color: AppColor.ColorGrayDottedLine,
            width: ScreenUtil().setWidth(75.0),
            strokeWidth: 2.0,
            dottedLength: 7.0,
            space: 2.0,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(15),
                right: ScreenUtil().setWidth(15)),
            child: Text(
              'OR Connect With',
              style: appThemeTextStyle(14, textColor: Colors.black),
            ),
          ),
          FDottedLine(
            color: AppColor.ColorGrayDottedLine,
            width: ScreenUtil().setWidth(75.0),
            strokeWidth: 2.0,
            dottedLength: 7.0,
            space: 2.0,
          ),
        ],
      ),
    );
  }

  Widget googleSignInBtn() {
    return Container(
      width: screenWidth(context),
      height: ScreenUtil().setHeight(52),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.12),
              blurRadius: 16,
              offset: Offset(0, 6)),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 0.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/LRF/ic_google.png'),
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setHeight(40),
            ),
            Text(
              'Login with Google',
              style: appThemeTextStyle(14,
                  fontWeight: FontWeight.w600,
                  textColor: Color.fromRGBO(12, 16, 36, 1)),
            ),
          ],
        ),
        onPressed: () {},
      ),
    );
  }

  Widget txtDontHaveAccount() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'If you don’t have an account?',
            textAlign: TextAlign.center,
            style: appThemeTextStyle(14,
                fontWeight: FontWeight.w600,
                textColor: Color.fromRGBO(106, 114, 147, 1)),
          ),
          TextButton(
            onPressed: () {
              _pressedOnSignUp();
            },
            child: Text(
              'Sign Up',
              textAlign: TextAlign.left,
              style: appThemeTextStyle(14,
                  fontWeight: FontWeight.w700, textColor: AppColor.ColorRed),
            ),
          )
        ],
      ),
    );
  }

  _pressedOnSignUp() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignUpScreen(widget.userType)));
  }

  _pressedOnForgotPassword() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
  }
}
