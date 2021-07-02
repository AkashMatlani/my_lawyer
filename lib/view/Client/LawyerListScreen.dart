import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/view/Client/LawyerDetailScreen.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';

class LawyerListScreen extends StatefulWidget {
  int selectedSegmentOption = 0;

  LawyerListScreen(this.selectedSegmentOption);

  @override
  _LawyerListScreenState createState() => _LawyerListScreenState();
}

class _LawyerListScreenState extends State<LawyerListScreen> {
  var adList = [
    'images/Client/temp_ad1.jpeg',
    'images/Client/temp_ad2.jpeg',
    'images/Client/temp_ad3.jpeg',
    'images/Client/temp_ad4.jpeg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Lawyer',
            style: appThemeTextStyle(20,
                fontWeight: FontWeight.w600, textColor: Colors.black)),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset('images/Sidebar/ic_burger.svg')),
        ),
      ),
      drawer: SideBarView(),
      body: lawyerListView(),
    );
  }

  Widget lawyerListView() {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          top: 20),
      child: Column(
        children: [sliderSegementView(), advertisementView(), lawyerList()],
      ),
    );
  }

  Widget sliderSegementView() {
    return Container(
      width: screenWidth(context),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.ColorBorder, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: CupertinoSlidingSegmentedControl(
        backgroundColor: Colors.white,
        thumbColor: AppColor.ColorYellowSegment,
        groupValue: widget.selectedSegmentOption,
        children: <int, Widget>{
          0: Text(
            'Hire',
            style: appThemeTextStyle(16,
                fontWeight: FontWeight.w700,
                textColor: (widget.selectedSegmentOption == 0)
                    ? Colors.white
                    : Color.fromRGBO(137, 143, 170, 1)),
          ),
          1: Text('Save',
              style: appThemeTextStyle(16,
                  fontWeight: FontWeight.w700,
                  textColor: (widget.selectedSegmentOption == 1)
                      ? Colors.white
                      : Color.fromRGBO(137, 143, 170, 1)))
        },
        onValueChanged: (selectedValue) {
          setState(() {
            widget.selectedSegmentOption = selectedValue as int;
          });
        },
      ),
    );
  }

  Widget advertisementView() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
      child: Container(
          width: screenWidth(context),
          height: ScreenUtil().setHeight(141),
          child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: adList.length,
              itemBuilder: (context, index) {
                return SizedBox(
                    width: screenWidth(context) - 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: AssetImage(adList[index]),
                        fit: BoxFit.fill,
                      ),
                    ));
              })),
    );
  }

  Widget lawyerList() {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
        child: ListView.builder(itemBuilder: (context, index) {
          return lawyerInfoView();
        }),
      ),
    );
  }

  Widget lawyerInfoView() {
    return Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(10),
          bottom: ScreenUtil().setHeight(10),
        ),
        child: Container(
          width: screenWidth(context),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColor.ColorBorder, width: 0.5),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.11), blurRadius: 2)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  lawyerProfilePicView(),
                  lawyerNameAndAbout(),
                  favoriteBtn(),
                ],
              ),
              bidRateAndLike(),
              viewDetailBtn()
            ],
          ),
        ));
  }

  Widget lawyerProfilePicView() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(10), left: ScreenUtil().setHeight(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(60) / 2),
        child: Image(
          image: AssetImage('images/Client/temp_ad1.jpeg'),
          fit: BoxFit.fill,
          width: ScreenUtil().setHeight(60),
          height: ScreenUtil().setHeight(60),
        ),
      ),
    );
  }

  Widget lawyerNameAndAbout() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(13),
          top: ScreenUtil().setHeight(13),
          right: ScreenUtil().setWidth(13)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Karen A Klein',
            style: appThemeTextStyle(16,
                fontWeight: FontWeight.w700, textColor: Colors.black),
          ),
          Text(
            'Outstanding attorney handling discrimination & business disputes.',
            style: TextStyle(),
          ),
        ],
      ),
    ));
  }

  Widget favoriteBtn() {
    return InkWell(
      child: SvgPicture.asset('images/Client/ic_fav.svg'),
      onTap: () {
        _pressedOnFavourite();
      },
    );
  }

  Widget lawyerAboutView() {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Text(
        'Outstanding attorney handling discrimination & business disputes.',
        style: TextStyle(),
      ),
    );
  }

  Widget bidRateAndLike() {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(17),
          right: ScreenUtil().setWidth(17),
          top: ScreenUtil().setHeight(12)),
      child: Container(
        width: screenWidth(context),
        height: ScreenUtil().setHeight(47),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColor.ColorBorder, width: 0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bid Rate',
                    style: appThemeTextStyle(13, textColor: Colors.black),
                  ),
                  Text(
                    r'$5000',
                    style: appThemeTextStyle(20,
                        textColor: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: ScreenUtil().setHeight(47),
              color: AppColor.ColorBorder,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Like',
                    style: appThemeTextStyle(13, textColor: Colors.black),
                  ),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image(
                            image: AssetImage('images/Client/ic_like.png'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            '489',
                            style: appThemeTextStyle(15,
                                textColor: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget viewDetailBtn() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(24),
          left: ScreenUtil().setWidth(16),
          right: ScreenUtil().setWidth(16),
          bottom: ScreenUtil().setHeight(16)),
      child: SizedBox(
          width: screenWidth(context),
          height: ScreenUtil().setHeight(38),
          child: GenericButton().appThemeButton(
              'View Detail', 16, Colors.white, FontWeight.w700, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LawyerDetailScreen()));
          }, borderRadius: 6)),
    );
  }

  _pressedOnFavourite() {}
}
