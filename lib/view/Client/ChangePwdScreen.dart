import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppMessages.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/StringExtension.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';

class ChangePwdScreen extends StatefulWidget {
  @override
  _ChangePwdScreenState createState() => _ChangePwdScreenState();
}

class _ChangePwdScreenState extends State<ChangePwdScreen> {
  var txtOldPwdController = TextEditingController();
  var txtNewPwdController = TextEditingController();
  var txtConfirmPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset('images/Sidebar/ic_burger.svg')),
        ),
      ),
      drawer: SideBarView(),
      body: changePwdView(),
    );
  }

  Widget changePwdView() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 12),
      child: Form(
          child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(children: [
          txtFieldPwd('Old Password', txtOldPwdController),
          txtFieldPwd('New Password', txtNewPwdController),
          txtFieldPwd('Confirm Password', txtConfirmPwdController),
          submitBtn()
        ]),
      )),
    );
  }

  Widget txtFieldPwd(String title, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField(
          title,
          TextInputType.emailAddress,
          controller,
          obscureText: true,
        ),
      ),
    );
  }

  Widget submitBtn() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
      child: SizedBox(
          width: screenWidth(context),
          height: ScreenUtil().setHeight(52),
          child: GenericButton()
              .appThemeButton('Submit', 16, Colors.white, FontWeight.w700, () {
            _pressedOnSubmit();
          }, borderRadius: 8)),
    );
  }

  _pressedOnSubmit() {
    if (txtOldPwdController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankOldPwd, context);
    } else if (txtNewPwdController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankNewPwd, context);
    } else if (txtNewPwdController.text.isValidPassword() == false) {
      AlertView().showAlert(Messages.CInvalidPassword, context);
    } else if (txtConfirmPwdController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankConfirmPassword, context);
    } else if (txtConfirmPwdController.text != txtNewPwdController.text) {
      AlertView().showAlert(Messages.CNewPasswordDoesNotMatch, context);
    } else {}
  }
}
