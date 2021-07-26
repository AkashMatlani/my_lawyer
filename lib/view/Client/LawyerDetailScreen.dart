import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/bloc/Client/AcceptProposalBloc.dart';
import 'package:my_lawyer/bloc/Client/LawyerDetailBloc.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/LawyerDetailModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/AcceptProposalRepository.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/CommonWidgets.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/LoadingView.dart';
import 'package:my_lawyer/utils/NetworkImage.dart';
import 'package:my_lawyer/view/Client/PaymentScreen.dart';

class LawyerDetailScreen extends StatefulWidget {
  int caseId;
  int lawyerId;
  String userName;
  bool isFromLawyerList;

  LawyerDetailScreen(
      this.caseId, this.lawyerId, this.userName, this.isFromLawyerList);

  @override
  _LawyerDetailScreenState createState() => _LawyerDetailScreenState();
}

class _LawyerDetailScreenState extends State<LawyerDetailScreen> {
  AcceptBidProposalBloc acceptBidProposalBloc;
  LawyerDetailBloc lawyerDetailBloc;

  LawyerDataModel lawyerDataModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    acceptBidProposalBloc = AcceptBidProposalBloc();
    lawyerDetailBloc = LawyerDetailBloc();
    getLawyerDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName,
            style: appThemeTextStyle(20,
                fontWeight: FontWeight.w600, textColor: Colors.black)),
      ),
      body: lawyerDetailStreamControllerBuild(),
    );
  }

  Widget lawyerDetailStreamControllerBuild() {
    return Container(
        child: StreamBuilder<APIResponse<LawyerDetailModel>>(
            stream: lawyerDetailBloc.lawyerDetailStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.Loading:
                    {
                      return Center(
                        child: LoadingView().loader(),
                      );
                    }
                    break;

                  case Status.Done:
                    {
                      lawyerDataModel = snapshot.data.data.data;
                      return lawyerDetailView();
                    }

                  case Status.Error:
                    return Center();
                    break;
                }
              } else {
                return showLoaderInList();
              }
            }));
  }

  Widget lawyerDetailView() {
    return
        // Container(
        //   child:
        Padding(
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
                if (!widget.isFromLawyerList) sendAcceptAndCancelBtn()
              ],
            ));
  }

  Widget userProfileInfo() {
    return Row(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(ScreenUtil().setHeight(80) / 2),
          child: (lawyerDataModel.userProfile == '')
              ? Image(
                  image: AssetImage('images/Client/ic_profile.jpeg'),
                  fit: BoxFit.fill,
                  width: ScreenUtil().setHeight(80),
                  height: ScreenUtil().setHeight(80),
                )
              : ImageNetwork().loadNetworkImage(
                  lawyerDataModel.userProfile, ScreenUtil().setHeight(60))),
      Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(10), right: ScreenUtil().setWidth(15)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                lawyerDataModel.lawyerName,
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
                      lawyerDataModel.email,
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
                      '${lawyerDataModel.likeCount}',
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
                  r'$' + '${lawyerDataModel.bidAmount}',
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
      lawyerDataModel.about,
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
    acceptBidProposalAPI();
  }

  _pressedOnCancel() {
    Navigator.of(context).pop();
  }

  getLawyerDetail() {
    // LoadingView().showLoaderWithTitle(true, context);
    lawyerDetailBloc.getLawyerDetail({
      'caseId': widget.caseId.toString(),
      'lawyerId': widget.lawyerId.toString()
    });
  }

  acceptBidProposalAPI() {
    Map<String, dynamic> params = {
      'caseId': widget.caseId.toString(),
      'lawyerId': widget.lawyerId.toString()
    };
    LoadingView().showLoaderWithTitle(true, context);
    acceptBidProposalBloc.acceptBidProposal(params);

    acceptBidProposalBloc.acceptBidStream.listen((snspshot) {
      switch (snspshot.status) {
        case Status.Loading:
          return LoadingView(loadingMessage: snspshot.message);

        case Status.Done:
          LoadingView().showLoaderWithTitle(false, context);
          AlertView().showToast(context, snspshot.data['meta']['message']);

          if (snspshot.data['meta']['status'] == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PaymentScreen()));
          }
          break;

        case Status.Error:
          LoadingView().showLoaderWithTitle(false, context);
          break;
      }
    });
  }
}
