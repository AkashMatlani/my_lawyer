import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/bloc/Client/CivilBloc.dart';
import 'package:my_lawyer/bloc/Client/CriminalBloc.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/CaseListModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/AppMessages.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/LoadingView.dart';

class CaseListScreen extends StatefulWidget {
  String appBarTitle;
  int caseType;
  var selectedCase;

  //0- Criminal, 1- Civil
  CaseListScreen(this.appBarTitle, this.caseType, this.selectedCase);

  @override
  _CaseListScreenState createState() => _CaseListScreenState();
}

class _CaseListScreenState extends State<CaseListScreen> {
  List<CaseModel> caseList;
  CivilBloc civilBloc;
  CriminalBloc criminalBloc;

  // var selectedCase = [];
  var isSelectedAll = false;

  @override
  void initState() {
    // TODO: implement initState
    caseList = [];
    civilBloc = CivilBloc();
    criminalBloc = CriminalBloc();

    if (widget.caseType == 0)
      criminalBloc.getCriminalList();
    else
      civilBloc.getCivilList();

    super.initState();
  }

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
      body: buildStream(),
    );
  }

  Widget buildStream() {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 247, 247, 1),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(15),
          ),
          child: StreamBuilder<APIResponse<CaseListModel>>(
              stream: (widget.caseType == 0)
                  ? criminalBloc.criminalStream
                  : civilBloc.civilStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.Loading:
                      return LoadingView().loader();
                      break;

                    case Status.Done:
                      caseList = snapshot.data.data.caseList;
                      return caseListView();

                    case Status.Error:
                      return Center(

                      );
                      break;
                  }
                } else {
                  return LoadingView().loader();
                }
              }),
        ));
  }

  Widget caseListView() {
    return Column(
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
    );
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
                  style: appThemeTextStyle(15,
                      textColor: AppColor.ColorBlack,
                      fontWeight: FontWeight.w700),
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

  Widget caseSelectionView(CaseModel caseInfo) {
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
                      value: widget.selectedCase.contains(caseInfo),
                      onChanged: (bool isSelected) {
                        setState(() {
                          if (isSelected)
                            widget.selectedCase.add(caseInfo);
                          else
                            widget.selectedCase.remove(caseInfo);
                        });
                      })),
              Text(
                caseInfo.name,
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
    if (widget.selectedCase.length == 0) {
      AlertView().showAlert(Messages.CBlankCase, context);
      return;
    }

    Navigator.pop(context, widget.selectedCase);
  }

  _pressedOnSelectAll() {
    isSelectedAll = !isSelectedAll;
    widget.selectedCase = [];
    setState(() {
      if (isSelectedAll) widget.selectedCase = caseList;
    });
  }
}
