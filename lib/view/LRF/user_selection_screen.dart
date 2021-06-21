import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_lawyer/generic_class/generic_button.dart';
import 'package:my_lawyer/generic_class/generic_textfield.dart';
import 'package:my_lawyer/utils/app_colors.dart';
import 'package:my_lawyer/utils/constant.dart';
import 'package:my_lawyer/view/LRF/tutorial_screen.dart';

class UserSelectionScreen extends StatefulWidget {
  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userSelectionView(),
    );
  }

  Widget userSelectionView() {
    return Container(
        decoration: BoxDecoration(color: AppColor.ColorBlack),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [logoImg(), bottomView()],
          ),
        ));
  }

  Widget logoImg() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(114)),
      child: SvgPicture.asset('images/LRF/ic_logo_title.svg'),
    );
  }

  Widget bottomView() {
    return Column(
      children: [
        Text(
          'Join the US\nlawyer market place',
          textAlign: TextAlign.center,
          style: appThemeTextStyle(32,
              fontWeight: FontWeight.w700, textColor: Colors.white),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 30),
          child: findButton(),
        )
      ],
    );
  }

  Widget findButton() {
    return SizedBox(
      height: ScreenUtil().setHeight(46),
      child: Row(
        children: [
          Expanded(
              child: GenericButton().appThemeButton(
                  'Find Lawyer', 16, Colors.white, FontWeight.w700, () {
            _pressedOnFindButton(0);
          })),
          SizedBox(width: ScreenUtil().setWidth(20)),
          Expanded(
              child: GenericButton().appThemeButton(
                  'Find Work', 16, Colors.white, FontWeight.w700, () {
            _pressedOnFindButton(1);
          }, bgColor: AppColor.ColorYellow)),
        ],
      ),
    );
  }

  _pressedOnFindButton(int userType) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TutorialScreen(userType)));
  }
}
