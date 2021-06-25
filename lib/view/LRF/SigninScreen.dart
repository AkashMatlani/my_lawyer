import 'dart:io';
import 'dart:ui';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_lawyer/bloc/SigninBloc.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/AppMessages.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/SocialLogin.dart';
import 'package:my_lawyer/utils/LoadingView.dart';
import 'package:my_lawyer/view/LRF/ForgotPasswordScreen.dart';
import 'package:my_lawyer/view/LRF/SignupScreen.dart';
import 'package:my_lawyer/utils/StringExtension.dart';
import 'package:my_lawyer/view/Client/LawyerListScreen.dart';
import 'package:my_lawyer/view/Lawyer/SearchCaseScreen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: <String>[
//     'email',
//   ],
// );

class SignInScreen extends StatefulWidget {
  int userType;

  SignInScreen(this.userType);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var txtEmailController = TextEditingController();
  var txtPwdController = TextEditingController();

  SignInBloc signInBloc;
  GoogleSignInAccount _currentUser;
  bool isUserSignedIn = false;
  GoogleSignInClass googleSignInClass = GoogleSignInClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signInBloc = SignInBloc();
  }

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
                    textSignIn(),
                    txtFieldEmail(),
                    txtFieldPwd(),
                    forgotPwdBtn(),
                    signInBtn(),
                    txtOrConnectWith(),
                    googleSignInBtn(),
                    if (Platform.isIOS) appleSignInBtn(),
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
          top: ScreenUtil().setHeight(12)),
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
            'Password', TextInputType.emailAddress, txtPwdController,
            prefixIcon: 'images/LRF/ic_pwd.svg',
            obscureText: true,
            hasPrefixIcon: true),
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
        child: GenericButton()
            .appThemeButton('Sign In', 16, Colors.white, FontWeight.w700, () {
          _pressedOnSignIn();
        }, borderRadius: 8));
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
          _pressedOngoogleSignIn();
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

  _pressedOnSignIn() {
    if (txtEmailController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankEmail, context);
    } else if (txtEmailController.text.isValidEmail() == false) {
      AlertView().showAlert(Messages.CInvalidEmail, context);
    } else if (txtPwdController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankPassword, context);
    } else {
      signInUser(SignInType.Normal, txtEmailController.text);
    }
  }

  _pressedOnSignUp() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignUpScreen(widget.userType)));
  }

  _pressedOnForgotPassword() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
  }

  signInUser(int signInType, String email) {
    Map<String, dynamic> params = {
      'email': email,
      'signInType': signInType.toString()
    };

    if (signInType == SignInType.Normal) {
      params['password'] = txtPwdController.text;
    }

    if (signInType == SignInType.Normal) {
      LoadingView().showLoaderWithTitle(true, context);
    }
    signInBloc.signInUser(params);

    signInBloc.signInStream.listen((snapshot) {
      switch (snapshot.status) {
        case Status.Loading:
          return LoadingView(loadingMessage: snapshot.message);

        case Status.Done:
          LoadingView().showLoaderWithTitle(false, context);
          if ((snapshot.data.meta as UserMetaModel).status == 1) {
            //...Redirect on Home Screen
            UserInfoModel userInfo = snapshot.data.data;
            storeUserInfo((snapshot.data.meta as UserMetaModel).token, {
              'userName': userInfo.userName,
              'userType': userInfo.userType,
              'userId': userInfo.userId,
              'userProfile': userInfo.userProfile,
              'signInType': userInfo.signInType,
              'email': userInfo.email,
              'about': userInfo.about
            }).then((value){
              if (widget.userType == UserType.User) {
                _navigateToLawyerHomeScreen();
              } else {
                _navigateToClientHomeScreen();
              }
            });

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

  _pressedOngoogleSignIn() {
    googleSignIn();
  }

  Future<void> googleSignIn() async {
    googleSignInClass.googleSignIn().then((currentUser) {
      LoadingView().showLoaderWithTitle(true, context);
      signInUser(SignInType.Google, currentUser.email);
    });
  }

  _pressedOnAppleSignIn() async {
    AppleSignInClass().appleSignIn().then((authDetail) {
      LoadingView().showLoaderWithTitle(true, context);
      signInUser(SignInType.Apple, authDetail.email);
    });
  }

  _navigateToLawyerHomeScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LawyerListScreen()));
  }

  _navigateToClientHomeScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCasesScreen()));
  }
}
