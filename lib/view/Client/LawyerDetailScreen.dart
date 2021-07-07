import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/view/Client/PaymentScreen.dart';

class LawyerDetailScreen extends StatefulWidget {
  @override
  _LawyerDetailScreenState createState() => _LawyerDetailScreenState();
}

class _LawyerDetailScreenState extends State<LawyerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case Detail',
            style: appThemeTextStyle(20,
                fontWeight: FontWeight.w600, textColor: Colors.black)),
      ),
      body: lawyerDetailView(),
    );
  }

  Widget lawyerDetailView() {
    return Container(
        child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      userProfileInfo(),
                      bidRateView(),
                      txtAboutUS(),
                      txtAboutUsView(),
                    ],
                  ),
                ),
                sendAcceptAndCancelBtn()
              ],
            )));
  }

  Widget userProfileInfo() {
    return Row(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(80) / 2),
        child: Image(
          image: AssetImage('images/Client/temp_ad1.jpeg'),
          fit: BoxFit.fill,
          width: ScreenUtil().setHeight(80),
          height: ScreenUtil().setHeight(80),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(10), right: ScreenUtil().setWidth(15)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Donald John-Mark Kenney',
                style: appThemeTextStyle(17,
                    fontWeight: FontWeight.w700, textColor: Colors.black),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(8),
                    bottom: ScreenUtil().setHeight(10)),
                child: Row(
                  children: [
                    SvgPicture.asset('images/Lawyer/ic_mail.svg'),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'donaldjohn@gmail.com',
                      style: appThemeTextStyle(14, textColor: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    // top: ScreenUtil().setHeight(7),
                    bottom: ScreenUtil().setHeight(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(AssetImage('images/Client/ic_like.png'),
                        color: Color.fromRGBO(153, 158, 181, 1)),
                    // SvgPicture.asset('images/Client/ic_like.svg'),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '413',
                      style: appThemeTextStyle(14, textColor: Colors.black),
                    ),
                  ],
                ),
              )
            ]),
      )
    ]);
  }

  Widget bidRateView() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(20), bottom: ScreenUtil().setHeight(20)),
      child: Container(
          height: ScreenUtil().setHeight(37),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColor.ColorAttachmentGray),
          child: Padding(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bid Rate',
                  style: appThemeTextStyle(14,
                      textColor: Color.fromRGBO(0, 0, 0, 0.6),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  r'$5000',
                  style: appThemeTextStyle(20,
                      textColor: Colors.black, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          )),
    );
  }

  Widget txtAboutUS() {
    return Text(
      'About Us',
      style: appThemeTextStyle(17,
          fontWeight: FontWeight.w700, textColor: Colors.black),
    );
  }

  Widget txtAboutUsView() {
    return Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam dignissim, metus efficitur ullamcorper dictum, eros tellus gravida mi, in luctus turpis magna ac urna. Phasellus venenatis magna odio, at ultrices nisi pellentesque eget. Ut bibendum pulvinar egestas. Quisque non purus a lorem facilisis posuere vitae eu leo purus a lorem.',
      style: appThemeTextStyle(15,
          textColor: Color.fromRGBO(0, 0, 0, 0.8), height: 2),
    );
  }

  Widget sendAcceptAndCancelBtn() {
    return Padding(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(32),
            bottom: ScreenUtil().setHeight(20)),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                  // width: screenWidth(context),
                  height: ScreenUtil().setHeight(52),
                  child: GenericButton().appThemeButton(
                      'Accept', 16, Colors.white, FontWeight.w700, () {
                    _pressedOnAccept();
                  }, borderRadius: 6)),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                  // width: screenWidth(context),
                  height: ScreenUtil().setHeight(52),
                  child: GenericButton().appThemeButton(
                      'Cancel', 16, Colors.black, FontWeight.w700, () {
                    _pressedOnCancel();
                  }, borderRadius: 6, bgColor: AppColor.ColorGrayDottedLine)),
            )
          ],
        ));
  }

  _pressedOnAccept() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PaymentScreen()));
  }

  _pressedOnCancel() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PaymentScreen()));
  }
}
