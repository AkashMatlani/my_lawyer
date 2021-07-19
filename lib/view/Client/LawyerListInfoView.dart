import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/bloc/Client/FavouriteLawyerBloc.dart';
import 'package:my_lawyer/bloc/Client/LikeLawyerBloc.dart';
import 'package:my_lawyer/bloc/Client/UnFavouriteLawyerBloc.dart';
import 'package:my_lawyer/bloc/Client/UnLikeBloc.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/NetworkImage.dart';
import 'package:my_lawyer/view/Client/LawyerDetailScreen.dart';

typedef getUpdatedLawyerDetail = Function(
    int index, LawyerDataModel lawyerDataModel);

// typedef getUpdatedLawyerDetail = Function(
//     int index, bool isSelected, bool isLike);

class LawyerListInfoView extends StatefulWidget {
  LawyerDataModel lawyerDataModel;
  int index;
  bool isFromLawyerList;
  getUpdatedLawyerDetail callBack;

  LawyerListInfoView(
      this.lawyerDataModel, this.index, this.isFromLawyerList, this.callBack);

  @override
  _LawyerListInfoViewState createState() => _LawyerListInfoViewState();
}

class _LawyerListInfoViewState extends State<LawyerListInfoView> {
  LikeLawyerBloc likeLawyerBloc = LikeLawyerBloc();
  UnLikeLawyerBloc unLikeLawyerBloc = UnLikeLawyerBloc();

  FavouriteLawyerBloc favouriteLawyerBloc = FavouriteLawyerBloc();
  UnFavouriteLawyerBloc unFavouriteLawyerBloc = UnFavouriteLawyerBloc();

  @override
  Widget build(BuildContext context) {
    return lawyerInfoView();
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
                  lawyerProfilePicView(widget.lawyerDataModel.userProfile),
                  lawyerNameAndAbout(widget.lawyerDataModel.about,
                      widget.lawyerDataModel.lawyerName),
                  favoriteBtn(widget.lawyerDataModel.isFav, widget.index),
                ],
              ),
              bidRateAndLike(
                  widget.lawyerDataModel.bidAmount,
                  widget.lawyerDataModel.isLike,
                  widget.lawyerDataModel.likeCount,
                  widget.index),
              viewDetailBtn(widget.lawyerDataModel)
            ],
          ),
        ));
  }

  Widget lawyerProfilePicView(String userProfile) {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(10), left: ScreenUtil().setHeight(10)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(ScreenUtil().setHeight(60) / 2),
          child: (userProfile == '')
              ? Image(
                  image: AssetImage(AppImage.CProfileImg),
                  fit: BoxFit.fill,
                  width: ScreenUtil().setHeight(60),
                  height: ScreenUtil().setHeight(60),
                )
              : ImageNetwork()
                  .loadNetworkImage(userProfile, ScreenUtil().setHeight(60))),
    );
  }

  Widget lawyerNameAndAbout(String about, String name) {
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
            name,
            style: appThemeTextStyle(16,
                fontWeight: FontWeight.w700, textColor: Colors.black),
          ),
          Text(
            about,
            style: TextStyle(),
          ),
        ],
      ),
    ));
  }

  Widget favoriteBtn(bool isFav, int index) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Image(
          image: isFav
              ? AssetImage('images/Client/ic_fav_selected.png')
              : AssetImage('images/Client/ic_fav.png'),
          width: ScreenUtil().setHeight(16),
          height: ScreenUtil().setHeight(16),
        ),
      ),

      // SvgPicture.asset(
      //   'images/Client/ic_fav.svg',
      //   color: isFav ? AppColor.ColorRed : Colors.transparent,
      // ),
      onTap: () {
        _pressedOnFavourite();
      },
    );
  }

  Widget bidRateAndLike(String amount, bool isLike, int likeCount, int index) {
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
                    '\$' + amount,
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
                    onTap: () {
                      _pressedOnLike();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image(
                            image: AssetImage('images/Client/ic_like.png'),
                            color: isLike
                                ? AppColor.ColorRed
                                : AppColor.ColorLikeGray,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            '$likeCount',
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

  Widget viewDetailBtn(LawyerDataModel lawyerInfo) {
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LawyerDetailScreen(
                        lawyerInfo.caseId,
                        lawyerInfo.lawyerId,
                        lawyerInfo.lawyerName,
                        widget.isFromLawyerList)));
          }, borderRadius: 6)),
    );
  }

  _pressedOnFavourite() {
    var updatedLawyerInfo = widget.lawyerDataModel;
    updatedLawyerInfo.isFav = !updatedLawyerInfo.isFav;

    widget.callBack(widget.index, updatedLawyerInfo);

    if (updatedLawyerInfo.isFav) {
      favouriteLawyerBloc.favLawyerProfile({
        'lawyerId': updatedLawyerInfo.lawyerId.toString(),
      });
    } else {
      unFavouriteLawyerBloc.unFavLawyerProfile({
        'lawyerId': updatedLawyerInfo.lawyerId.toString(),
      });
    }
  }

  _pressedOnLike() {
    var updatedLawyerInfo = widget.lawyerDataModel;
    updatedLawyerInfo.isLike = !updatedLawyerInfo.isLike;
    updatedLawyerInfo.likeCount = (updatedLawyerInfo.isLike)
        ? updatedLawyerInfo.likeCount + 1
        : updatedLawyerInfo.likeCount - 1;

    widget.callBack(widget.index, updatedLawyerInfo);

    if (updatedLawyerInfo.isLike) {
      likeLawyerBloc.likeLawyerProfile({
        'lawyerId': updatedLawyerInfo.lawyerId.toString(),
        'caseId': updatedLawyerInfo.caseId.toString()
      });
    } else {
      unLikeLawyerBloc.unLikeLawyerProfile({
        'lawyerId': updatedLawyerInfo.lawyerId.toString(),
        'caseId': updatedLawyerInfo.caseId.toString()
      });
    }
  }
}
