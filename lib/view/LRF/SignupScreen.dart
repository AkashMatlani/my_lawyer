import 'dart:convert';
import 'dart:io';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/AppMessages.dart';
import 'package:my_lawyer/utils/CommonStuff.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_lawyer/bloc/LRF/SignupBloc.dart';
import 'package:my_lawyer/utils/FCMService.dart';
import 'package:my_lawyer/utils/LoadingView.dart';
import 'package:my_lawyer/utils/StringExtension.dart';
import 'package:my_lawyer/utils/SocialLogin.dart';
import 'package:my_lawyer/view/Client/Create%20Case/CreateCaseScreen.dart';
import 'package:my_lawyer/view/LRF/SigninScreen.dart';
import 'package:my_lawyer/view/Client/LawyerListScreen.dart';
import 'package:my_lawyer/view/Lawyer/SearchCaseScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignUpScreen extends StatefulWidget {
  int userType;

  SignUpScreen(this.userType);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var txtUserNameController = TextEditingController();
  var txtEmailController = TextEditingController();
  var txtPwdController = TextEditingController();
  var txtConfirmPwdController = TextEditingController();
  var txtAboutController = TextEditingController();

  SignUpBloc signUpBloc = SignUpBloc();
  GoogleSignInClass googleSignInClass = GoogleSignInClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: signUpView(),
    );
  }

  Widget signUpView() {
    return Container(
      child: Column(
        children: [logoImg(), signUpContainerView()],
      ),
    );
  }

  Widget logoImg() {
    return Image(
      image: AssetImage('images/LRF/ic_login_logo.png'),
      fit: BoxFit.fill,
    );
  }

  Widget signUpContainerView() {
    return Expanded(
        flex: 1,
        child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 0),
            child: Form(
                child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  textSignUp(),
                  txtFieldUserName(),
                  txtFieldEmail(),
                  txtFieldPwd(),
                  txtFieldConfirmPwd(),
                  if (widget.userType == UserType.Lawyer) txtViewAbout(),
                  signUpBtn(),
                  txtOrConnectWith(),
                  googleSignInBtn(),
                  txtDontHaveAccount()
                ],
              ),
            ))));
  }

  Widget textSignUp() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(23)),
      child: Text(
        'Sign Up',
        style: appThemeTextStyle(28,
            textColor: Colors.black, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget txtFieldUserName() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField(
            'User Name', TextInputType.name, txtUserNameController,
            prefixIcon: 'images/LRF/ic_user.svg', hasPrefixIcon: true),
      ),
    );
  }

  Widget txtFieldEmail() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField(
            'Email ID', TextInputType.emailAddress, txtEmailController,
            prefixIcon: 'images/LRF/ic_email.svg', hasPrefixIcon: true),
      ),
    );
  }

  Widget txtFieldPwd() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField(
            'Password', TextInputType.visiblePassword, txtPwdController,
            prefixIcon: 'images/LRF/ic_pwd.svg',
            obscureText: true,
            hasPrefixIcon: true),
      ),
    );
  }

  Widget txtFieldConfirmPwd() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField('Confirm Password',
            TextInputType.visiblePassword, txtConfirmPwdController,
            prefixIcon: 'images/LRF/ic_pwd.svg',
            obscureText: true,
            hasPrefixIcon: true),
      ),
    );
  }

  Widget txtViewAbout() {
    return Padding(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(12),
            bottom: ScreenUtil().setHeight(12)),
        child: appThemeTextField(
            'About YourSelf', TextInputType.name, txtAboutController,
            maxLines: 4,
            prefixIcon: 'images/LRF/ic_user.svg',
            bottomPaddingPrefixImg: 70,
            hasPrefixIcon: true));
  }

  Widget signUpBtn() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
      child: SizedBox(
          width: screenWidth(context),
          height: ScreenUtil().setHeight(52),
          child: GenericButton()
              .appThemeButton('Sign Up', 16, Colors.white, FontWeight.w700, () {
            _pressOnSignUp();
          }, borderRadius: 8)),
    );
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
        onPressed: () {
          pressedOngoogleSignIn();
        },
      ),
    );
  }

  Widget appleSignInBtn() {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(20),
      ),
      child: SignInWithAppleButton(onPressed: () {
        _pressedOnAppleSignIn();
      }),
    );
  }

  Widget txtDontHaveAccount() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'If you have an account?',
            textAlign: TextAlign.center,
            style: appThemeTextStyle(14,
                fontWeight: FontWeight.w600,
                textColor: Color.fromRGBO(106, 114, 147, 1)),
          ),
          TextButton(
            onPressed: () {
              _pressedOnSignIn();
            },
            child: Text(
              'Sign In',
              textAlign: TextAlign.left,
              style: appThemeTextStyle(14,
                  fontWeight: FontWeight.w700, textColor: AppColor.ColorRed),
            ),
          )
        ],
      ),
    );
  }

  _pressOnSignUp() {
    if (txtUserNameController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankUserName, context);
    } else if (txtEmailController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankEmail, context);
    } else if (txtEmailController.text.isValidEmail() == false) {
      AlertView().showAlert(Messages.CInvalidEmail, context);
    } else if (txtPwdController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankPassword, context);
    } else if (txtPwdController.text.isValidPassword() == false) {
      AlertView().showAlert(Messages.CInvalidPassword, context);
    } else if (txtConfirmPwdController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankConfirmPassword, context);
    } else if (txtConfirmPwdController.text != txtPwdController.text) {
      AlertView().showAlert(Messages.CPasswordDoesNotMatch, context);
    } else {
      signUpUser({
        'userName': txtUserNameController.text,
        'email': txtEmailController.text,
        'signInType': SignInType.Normal.toString()
      });
    }
  }

  signUpUser(Map<String, dynamic> params) {
    Map<String, dynamic> signUpInfo = params;

    signUpInfo['userType'] = widget.userType.toString();

    if (widget.userType == UserType.Lawyer) {
      params['about'] = txtAboutController.text;
    }

    if (int.parse(params['signInType']) == SignInType.Normal) {
      params['password'] = txtPwdController.text;
      LoadingView().showLoaderWithTitle(true, context);
    }

    signUpBloc.signUpUser(params);

    signUpBloc.signUpStream.listen((snapshot) {
      switch (snapshot.status) {
        case Status.Loading:
          return LoadingView(loadingMessage: snapshot.message);

        case Status.Done:
          LoadingView().showLoaderWithTitle(false, context);
          if ((snapshot.data.meta as UserMetaModel).status == 1) {
            //...Redirect on Home Screen

            print('SuccessFull');
            UserInfoModel userInfo = snapshot.data.data;
            storeUserInfo((snapshot.data.meta as UserMetaModel).token, {
              'userName': userInfo.userName,
              'userType': userInfo.userType,
              'userId': userInfo.userId,
              'userProfile': userInfo.userProfile,
              'signInType': userInfo.signInType,
              'email': userInfo.email,
              'about': userInfo.about
            });


            registeredDeviceToken();

            if (widget.userType == UserType.User) {
              _navigateToCreateCaseScreen();
            } else {
              _navigateToClientHomeScreen();
            }
          } else {
            AlertView().showAlertView(
                context,
                (snapshot.data.meta as UserMetaModel).message,
                () => {Navigator.of(context).pop()});
          }
          break;

        case Status.Error:
          LoadingView().showLoaderWithTitle(false, context);
          AlertView().showAlertView(
              context, snapshot.message, () => {Navigator.of(context).pop()});
          break;
      }
    });
  }

  _pressedOnSignIn() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInScreen(widget.userType)));
  }

  Future<void> pressedOngoogleSignIn() async {
    googleSignInClass.googleSignIn().then((currentUser) {
      LoadingView().showLoaderWithTitle(true, context);

      signUpUser({
        'userName': currentUser.displayName,
        'email': currentUser.email,
        'signInType': SignInType.Google.toString()
      });
    });
  }

  _pressedOnAppleSignIn() async {
    AppleSignInClass().appleSignIn().then((userDetail) {
      LoadingView().showLoaderWithTitle(true, context);
      signUpUser({
        'userName': userDetail['name'],
        'email': userDetail['email'],
        'signInType': SignInType.Apple.toString()
      });
    });
  }

  _navigateToCreateCaseScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateCaseScreen()));
  }

  _navigateToClientHomeScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchCasesScreen()));
  }
}
