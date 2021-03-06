import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'dart:core';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/view/LRF/SigninScreen.dart';
import 'package:my_lawyer/view/LRF/SignupScreen.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class TutorialScreen extends StatefulWidget {
  int userType;

  TutorialScreen(this.userType);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  List<Map> tutorialClientList = [
    {
      'img': 'images/LRF/ic_client_tutorial1.svg',
      'title': 'A global talent network for\nlawyers hired.',
      'desc': 'Find professionals lawyers and\nfirms for any cases.'
    },
    {
      'img': 'images/LRF/ic_client_tutorial2.svg',
      'title': 'Post cases and\nget proposals.',
      'desc': 'Interview your favorites\nand hire the best fit.'
    },
    {
      'img': 'images/LRF/ic_client_tutorial3.svg',
      'title': 'Make payment easily.',
      'desc':
          'See your transactions, get invoices,\nand only pay for approved cases.'
    }
  ];

  List<Map> tutorialLawyerList = [
    {
      'img': 'images/LRF/ic_lawyer_tutorial1.svg',
      'title': 'Never miss an opportunity.',
      'desc': 'Easily find work, chat, and\ncollaborate on the go.'
    },
    {
      'img': 'images/LRF/ic_lawyer_tutorial2.svg',
      'title': 'Find interesting cases\nand submit proposals.',
      'desc': 'Easily find work, chat, and\ncollaborate on the go.'
    },
    {
      'img': 'images/LRF/ic_lawyer_tutorial3.svg',
      'title': 'Collaborate on the go.',
      'desc': 'Chat, share files, and complete\nprojects.'
    }
  ];

  PageController pageController = PageController();
  final currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tutorialView(),
    );
  }

  Widget tutorialView() {
    return Container(
      decoration: BoxDecoration(color: AppColor.ColorBlack),
      child: Center(
        child: Column(
          children: [
            logoImg(),
            pageViewList(),
            pageIndicatorView(),
            bottomSignInView()
          ],
        ),
      ),
    );
  }

  Widget logoImg() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(79)),
      child: SvgPicture.asset(
        'images/LRF/ic_logo.svg',
        width: ScreenUtil().setWidth(203),
        height: ScreenUtil().setHeight(70),
      ),
    );
  }

  Widget pageViewList() {
    return Flexible(
        child: Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(26), bottom: ScreenUtil().setHeight(16)),
      child: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        itemCount: (widget.userType == UserType.User)
            ? tutorialClientList.length
            : tutorialLawyerList.length,
        itemBuilder: (context, index) {
          return pageViewCard((widget.userType == UserType.User)
              ? tutorialClientList[index]
              : tutorialLawyerList[index]);
        },
        onPageChanged: (selectedIndex) {
          setState(() {
            currentPageNotifier.value = selectedIndex;
          });
        },
      ),
    ));
  }

  Widget pageViewCard(Map tutorialInfo) {
    return Column(
      children: [
        SvgPicture.asset(
          tutorialInfo['img'],
          height: ScreenUtil().setHeight(260),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(7),
              bottom: ScreenUtil().setHeight(24)),
          child: Text(
            tutorialInfo['title'],
            textAlign: TextAlign.center,
            style: appThemeTextStyle(26,
                fontWeight: FontWeight.w700,
                textColor: Color.fromRGBO(254, 254, 254, 1),
                height: 1.3),
          ),
        ),
        Text(
          tutorialInfo['desc'],
          textAlign: TextAlign.center,
          style: appThemeTextStyle(16,
              fontWeight: FontWeight.w400,
              textColor: Colors.white,
              height: 1.2),
        ),
      ],
    );
  }

  Widget pageIndicatorView() {
    return CirclePageIndicator(
      currentPageNotifier: currentPageNotifier,
      itemCount: (widget.userType == UserType.User)
          ? tutorialClientList.length
          : tutorialLawyerList.length,
      dotColor: AppColor.ColorDarkGray,
      selectedDotColor: AppColor.ColorYellow,
      dotSpacing: 3,
      size: ScreenUtil().setWidth(10),
    );
  }

  Widget bottomSignInView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: ScreenUtil().setHeight(38),
              // bottom: ScreenUtil().setHeight(10)
          ),
          child: SizedBox(
              width: screenWidth(context),
              height: ScreenUtil().setHeight(49),
              child: GenericButton().appThemeButton(
                  'Sign In', 16, Colors.white, FontWeight.w700, () {
                _pressedOnSignIn();
              }, borderRadius: 8)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'New to My Lawyer?',
              textAlign: TextAlign.center,
              style: appThemeTextStyle(14,
                  fontWeight: FontWeight.w600,
                  textColor: AppColor.ColorLightGray),
            ),
            TextButton(
              onPressed: () {
                _pressedOnSignUp();
              },
              child: Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: appThemeTextStyle(16,
                    fontWeight: FontWeight.w700, textColor: AppColor.ColorRed),
              ),
            )
          ],
        ),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: TextButton(
                    onPressed: _pressedOnSkip,
                    child: Text(
                      'Skip',
                      textAlign: TextAlign.center,
                      style: appThemeTextStyle(14,
                          fontWeight: FontWeight.w600,
                          textColor: AppColor.ColorLightGray,
                          isShowUnderline: true),
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }

  _pressedOnSignIn() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInScreen(widget.userType)));
  }

  _pressedOnSignUp() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignUpScreen(widget.userType)));
  }

  _pressedOnSkip() {

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInScreen(widget.userType)));

    // if (currentPageNotifier.value == 2) {
    //   return;
    // }
    //
    // setState(() {
    //   currentPageNotifier.value += 1;
    //   pageController.animateToPage(currentPageNotifier.value,
    //       duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    // });
  }
}
