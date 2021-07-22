import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/BidListModel.dart';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/NetworkImage.dart';
import 'package:my_lawyer/view/Client/LawyerDetailScreen.dart';
import 'package:my_lawyer/view/Lawyer/CaseDetailScreen.dart';

enum CaseStatus { MyCase, MyBid, Other }

class CaseInfoView extends StatefulWidget {
  int userType;
  CaseDataModel caseInfo;
  BidDataModel bidDetail;
  CaseStatus status;

  CaseInfoView(int lawyer,
      {this.userType,
      this.caseInfo,
      this.bidDetail,
      this.status = CaseStatus.Other});

  @override
  _CaseInfoViewState createState() => _CaseInfoViewState();
}

class _CaseInfoViewState extends State<CaseInfoView> {
  @override
  Widget build(BuildContext context) {
    print('Case Info - ${widget.caseInfo}');
    print('Lawyer Info - ${widget.bidDetail}');

    return caseInfoView();
  }

  Widget caseInfoView() {
    return Padding(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(10),
            bottom: ScreenUtil().setHeight(10),
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
        child: Container(
          width: screenWidth(context),
          // height: ScreenUtil().setHeight(214),
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
              Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [lawyerProfilePicView(), caseInfo()],
                  )),
              viewDetailBtn()
            ],
          ),
        ));
  }

  Widget lawyerProfilePicView() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(65) / 2),
        child: ((widget.caseInfo == null)
                ? widget.bidDetail.userProfile == ''
                : widget.caseInfo.userProfile == '')
            ? Image(
                image: AssetImage(AppImage.CProfileImg),
                fit: BoxFit.fill,
                width: ScreenUtil().setHeight(65),
                height: ScreenUtil().setHeight(65),
              )
            : ImageNetwork().loadNetworkImage(
                ((widget.caseInfo == null)
                    ? widget.bidDetail.userProfile
                    : widget.caseInfo.userProfile),
                ScreenUtil().setHeight(65)));
  }

  Widget caseInfo() {
    return Padding(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(13)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            (widget.caseInfo == null)
                ? widget.bidDetail.userName
                : widget.caseInfo.userName,
            style: appThemeTextStyle(16,
                fontWeight: FontWeight.w700, textColor: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(211, 255, 211, 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    (widget.caseInfo == null)
                        ? widget.bidDetail.caseType
                        : widget.caseInfo.caseType,
                    textAlign: TextAlign.center,
                    style: appThemeTextStyle(13,
                        fontWeight: FontWeight.w600,
                        textColor: Color.fromRGBO(2, 165, 64, 1)),
                  ),
                )),
          ),
          if (widget.status != CaseStatus.MyCase)
            Row(children: [
              Text(
                'Amount:',
                style: appThemeTextStyle(14,
                    textColor: Color.fromRGBO(98, 106, 142, 1)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  (widget.caseInfo == null)
                      ? widget.bidDetail.bidAmount
                      : widget.caseInfo.amount,
                  style: appThemeTextStyle(14, textColor: Colors.black),
                ),
              )
            ])
        ],
      ),
    );
  }

  Widget viewDetailBtn() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(5),
          left: ScreenUtil().setWidth(15),
          right: ScreenUtil().setWidth(15),
          bottom: ScreenUtil().setHeight(15)),
      child: SizedBox(
          width: screenWidth(context),
          height: ScreenUtil().setHeight(38),
          child: GenericButton().appThemeButton(
              'View Detail', 16, Colors.white, FontWeight.w700, () {
            _pressedOnViewDetail();
          }, borderRadius: 6)),
    );
  }

  _pressedOnViewDetail() {
    if (widget.status == CaseStatus.Other) {
      if (widget.userType == UserType.User)
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LawyerDetailScreen(
                    widget.bidDetail.caseId,
                    widget.bidDetail.userId,
                    widget.bidDetail.userName,
                    false)));
      else {
        final caseDetailScreen = CaseDetailScreen(
            caseId: (widget.caseInfo != null)
                ? widget.caseInfo.caseId
                : widget.bidDetail.caseId);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => caseDetailScreen));
      }
    } else {
      final caseDetailScreen = CaseDetailScreen(
        caseId: (widget.caseInfo != null)
            ? widget.caseInfo.caseId
            : widget.bidDetail.caseId,
        isFromMyCase: true,
      );

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => caseDetailScreen));
    }
  }
}
