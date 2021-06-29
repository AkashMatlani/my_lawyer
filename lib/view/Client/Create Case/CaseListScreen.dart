import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/Constant.dart';

class CaseListScreen extends StatefulWidget {
  String appBarTitle;
  int caseType;

  //0- Criminal, 1- Civil
  CaseListScreen(this.appBarTitle, this.caseType);

  @override
  _CaseListScreenState createState() => _CaseListScreenState();
}

class _CaseListScreenState extends State<CaseListScreen> {
  var caseList = [
    {'id': 1, 'name': 'Assignment Case'},
    {'id': 2, 'name': 'Review Hearing'},
    {'id': 3, 'name': 'Show Case Hearing'},
    {'id': 4, 'name': 'Bond Hearing'},
    {'id': 5, 'name': 'Final Free Trial Hearing'},
    {'id': 6, 'name': 'Trial'},
    {'id': 7, 'name': 'Jurry Trial'},
  ];

  var selectedCase = [];
  var isSelectedAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.appBarTitle),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
              color: Colors.black,
            ),
          )),
      body: caseListView(),
    );
  }

  Widget caseListView() {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 247, 247, 1),
        ),
        child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(15),
            ),
            child: Column(
              children: [
                selectAllCaseView(),
                Flexible(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: caseList.length,
                      itemBuilder: (context, index) {
                        return caseSelectionView(caseList[index]);
                      }),
                ),
                submitBtn()
              ],
            )));
  }

  Widget selectAllCaseView() {
    return Padding(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
      child: Container(
        height: 40,
        child: InkWell(
          child: Row(
            children: [
              Image(
                  image: AssetImage(isSelectedAll
                      ? 'images/Client/ic_select_circle.png'
                      : 'images/Client/ic_unselect_circle.png')),
              Padding(
                padding: EdgeInsets.only(left: 7),
                child: Text(
                  'Select All',
                  style: appThemeTextStyle(15, textColor: AppColor.ColorBlack, fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
          onTap: () {
            _pressedOnSelectAll();
          },
        ),
      ),
    );
  }

  Widget caseSelectionView(Map<String, dynamic> caseInfo) {
    return Padding(
        padding:
            EdgeInsets.only(left: ScreenUtil().setWidth(5), top: 0, bottom: 0),
        child: Container(
          height: ScreenUtil().setHeight(35),
          child: Row(
            children: [
              Theme(
                  data: ThemeData(
                      unselectedWidgetColor: Color.fromRGBO(213, 213, 213, 1)),
                  child: Checkbox(
                      activeColor: AppColor.ColorRed,
                      value: selectedCase.contains(caseInfo),
                      onChanged: (bool isSelected) {
                        setState(() {
                          if (isSelected)
                            selectedCase.add(caseInfo);
                          else
                            selectedCase.remove(caseInfo);
                        });
                      })),
              Text(
                caseInfo['name'],
                style: appThemeTextStyle(14, textColor: AppColor.ColorBlack),
              ),
            ],
          ),
        ));
  }

  Widget submitBtn() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: ScreenUtil().setHeight(30),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20)),
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
    Navigator.pop(context, selectedCase);
  }

  _pressedOnSelectAll() {
    isSelectedAll = !isSelectedAll;
    selectedCase = [];
    setState(() {
      if (isSelectedAll) selectedCase = caseList;
    });
  }
}
