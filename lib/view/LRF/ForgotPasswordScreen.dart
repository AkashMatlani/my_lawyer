import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_lawyer/bloc/LRF/ForgotPwdBloc.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppMessages.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/LoadingView.dart';
import 'package:my_lawyer/utils/StringExtension.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var txtEmailController = TextEditingController();

  ForgotPwdBloc forgotPwdBloc;

  @override
  initState() {
    super.initState();
    forgotPwdBloc = ForgotPwdBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: appThemeTextStyle(20,
              fontWeight: FontWeight.w600, textColor: Colors.black),
        ),
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
        child: GenericButton()
            .appThemeButton('Submit', 16, Colors.white, FontWeight.w700, () {
          _pressedOnSubmit();
        }, borderRadius: 8));
  }

  _pressedOnSubmit() {
    if (txtEmailController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankEmail, context);
    } else if (txtEmailController.text.isValidEmail() == false) {
      AlertView().showAlert(Messages.CInvalidEmail, context);
    } else {
      forgotPwd();
    }
  }

  forgotPwd() {
    LoadingView().showLoaderWithTitle(true, context);
    forgotPwdBloc.forgotPwd(txtEmailController.text);

    forgotPwdBloc.forgotPwdStream.listen((snapshot) {
      switch (snapshot.status) {
        case Status.Loading:
          return LoadingView(loadingMessage: snapshot.message);

        case Status.Done:
          LoadingView().showLoaderWithTitle(false, context);

          if (snapshot.data['meta']['status'] == 1) {
            AlertView().showAlertView(context, snapshot.data['meta']['message'],
                () => {Navigator.of(context)..pop()..pop()});
          } else {
            AlertView().showAlertView(context, snapshot.data['meta']['message'],
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
}
