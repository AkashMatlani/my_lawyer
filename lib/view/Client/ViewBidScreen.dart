import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/bloc/Client/BidListBloc.dart';
import 'package:my_lawyer/bloc/Client/FavouriteLawyerBloc.dart';
import 'package:my_lawyer/bloc/Client/LikeLawyerBloc.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/BidListModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/CommonWidgets.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/LoadingView.dart';
import 'package:my_lawyer/utils/NetworkImage.dart';
import 'package:my_lawyer/view/Client/LawyerDetailScreen.dart';
import 'package:my_lawyer/view/Client/LawyerListInfoView.dart';
import 'package:my_lawyer/view/Lawyer/CaseInfoView.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewBidScreen extends StatefulWidget {
  @override
  _ViewBidScreenState createState() => _ViewBidScreenState();
}

class _ViewBidScreenState extends State<ViewBidScreen> {
  int userType = 0;

  int currentPage = 1;
  int totalCount = 0;
  List<LawyerDataModel> bidList = [];
  bool isUpdateList = false;

  ScrollController scrollController = ScrollController();

  BidListBloc bidListBloc;
  LikeLawyerBloc likeLawyerBloc = LikeLawyerBloc();
  FavouriteLawyerBloc favouriteLawyerBloc = FavouriteLawyerBloc();

  @override
  initState() {
    SharedPreferences.getInstance().then((prefs) {
      var userInfoStr = prefs.getString(UserPrefernces.UserInfo);

      setState(() {
        var userInfo = json.decode(userInfoStr);
        userType = userInfo['userType'];
      });
    });

    bidListBloc = BidListBloc();
    super.initState();

    pullToRefresh();

    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Bids',
            style: appThemeTextStyle(20,
                fontWeight: FontWeight.w600, textColor: Colors.black)),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset('images/Sidebar/ic_burger.svg')),
        ),
      ),
      drawer: SideBarView(),
      body: bidStreamControllerBuilder(),
    );
  }

  Widget bidStreamControllerBuilder() {
    return RefreshIndicator(
        backgroundColor: AppColor.ColorRed,
        color: Colors.white,
        child: StreamBuilder<APIResponse<LawyerListModel>>(
            stream: bidListBloc.bidListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.Loading:
                    {
                      if (currentPage == 1) {
                        return Center(
                          child: LoadingView().loader(),
                        );
                      } else {
                        if (bidList.length > 0) {
                          return bidListView();
                        }
                      }
                    }
                    break;

                  case Status.Done:
                    {
                      if (currentPage == 1) {
                        bidList.clear();
                      }

                      if (!isUpdateList) {
                        if (bidList.length <= totalCount) {
                          currentPage = currentPage + 1;
                        }

                        if (snapshot.data.data.data.length > 0) {
                          bidList = bidList + snapshot.data.data.data;
                          totalCount = snapshot.data.data.meta.count;
                        }
                      }

                      if (bidList.length > 0) {
                        return bidListView();
                      } else {
                        return widgetNotAvailableData('Bid list not found.');
                      }
                      break;
                    }

                  case Status.Error:
                    AlertView()
                        .showAlertView(context, snapshot.data.message, () {});
                }
              } else {
                return showLoaderInList();
              }
            }),
        onRefresh: () async {
          pullToRefresh();
        });
  }

  Widget bidListView() {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: bidList.length,
          itemBuilder: (context, index) {
            return LawyerListInfoView(bidList[index], index, false,
                (index, bidInfo) {
              setState(() {
                isUpdateList = true;
                bidList[index] = bidInfo;
                print('Length - ${bidList.length}');
              });
            }); //CaseInfoView(UserType.Lawyer, bidDetail: bidList[index]);
          }),
    );
  }

  pullToRefresh() {
    isUpdateList = false;
    currentPage = 1;
    totalCount = 0;
    bidListBloc
        .getBidList({'currentPage': currentPage.toString(), 'limit': '5'});
  }

  loadMore() {
    if (bidList.length <= totalCount) {
      isUpdateList = false;
      bidListBloc
          .getBidList({'currentPage': currentPage.toString(), 'limit': '5'});
    }
  }
}
