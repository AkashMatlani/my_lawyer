import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/view/Lawyer/CaseInfoView.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';
import 'package:flutter/cupertino.dart';

class SearchCasesScreen extends StatefulWidget {
  @override
  _SearchCasesScreenState createState() => _SearchCasesScreenState();
}

class _SearchCasesScreenState extends State<SearchCasesScreen> {
  int selectedCase = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Case',style: appThemeTextStyle(20,
            fontWeight: FontWeight.w600, textColor: Colors.black)),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset('images/Sidebar/ic_burger.svg')),
        ),
      ),
      drawer: SideBarView(),
      body: searchCaseListView(),
    );
  }

  Widget searchCaseListView() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [sliderSegementView(), searchCaseList()],
      ),
    );
  }

  Widget sliderSegementView() {
    return Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
        child: Container(
          width: screenWidth(context),
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.ColorBorder, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: CupertinoSlidingSegmentedControl(
            backgroundColor: Colors.white,
            thumbColor: AppColor.ColorYellowSegment,
            groupValue: selectedCase,
            children: <int, Widget>{
              0: Text(
                'Criminal',
                style: appThemeTextStyle(16,
                    fontWeight: FontWeight.w700,
                    textColor: (selectedCase == 0)
                        ? Colors.white
                        : Color.fromRGBO(137, 143, 170, 1)),
              ),
              1: Text('Civil',
                  style: appThemeTextStyle(16,
                      fontWeight: FontWeight.w700,
                      textColor: (selectedCase == 1)
                          ? Colors.white
                          : Color.fromRGBO(137, 143, 170, 1))),
              2: Text('Custom',
                  style: appThemeTextStyle(16,
                      fontWeight: FontWeight.w700,
                      textColor: (selectedCase == 2)
                          ? Colors.white
                          : Color.fromRGBO(137, 143, 170, 1)))
            },
            onValueChanged: (selectedValue) {
              setState(() {
                selectedCase = selectedValue as int;
              });
            },
          ),
        ));
  }

  Widget searchCaseList() {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
        child: ListView.builder(itemBuilder: (context, index) {
          return CaseInfoView();
        }),
      ),
    );
  }
}
