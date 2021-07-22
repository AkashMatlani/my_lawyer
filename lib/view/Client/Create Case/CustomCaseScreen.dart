import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/AppMessages.dart';
import 'package:my_lawyer/utils/Constant.dart';

class CustomCaseScreen extends StatefulWidget {
  @override
  _CustomCaseScreenState createState() => _CustomCaseScreenState();
}

class _CustomCaseScreenState extends State<CustomCaseScreen> {
  var txtCustomCaseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Custom Case'),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
              color: Colors.black,
            ),
          )),
      body: customCaseView(),
    );
  }

  Widget customCaseView() {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 247, 247, 1),
        ),
        child: Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(24),
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20)),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        'Add Description ',
                        style: appThemeTextStyle(14,
                            fontWeight: FontWeight.w600,
                            textColor: Colors.black),
                      ),
                    ),
                    appThemeTextField('Write Your Description Here…',
                        TextInputType.name, txtCustomCaseController,
                        maxLines: 9,
                        borderColor: AppColor.ColorBorder,
                        fontSize: 14,
                        topPadding: 30,
                        fillColor: Colors.white,
                        filled: true)
                  ],
                ),
                Spacer(),
                submitBtn()
              ],
            )));
  }

  Widget submitBtn() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(30),
      ),
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
    if (txtCustomCaseController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankCustomDesc, context);
      return;
    }
    Navigator.pop(context, txtCustomCaseController.text);
  }
}
