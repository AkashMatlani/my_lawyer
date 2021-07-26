import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/bloc/Client/BidListBloc.dart';
import 'package:my_lawyer/bloc/Client/FavouriteLawyerBloc.dart';
import 'package:my_lawyer/bloc/Client/LikeLawyerBloc.dart';
import 'package:my_lawyer/bloc/Client/MyCaseBloc.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/BidListModel.dart';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';
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

class MyCasesScreen extends StatefulWidget {
  @override
  _MyCasesScreenState createState() => _MyCasesScreenState();
}

class _MyCasesScreenState extends State<MyCasesScreen> {
  int userType = 0;

  int currentPage = 1;
  int totalCount = 0;
  List<CaseDataModel> caseList = [];
  bool isUpdateList = false;

  MyCaseBloc myCaseBloc = MyCaseBloc();
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    pullToRefresh();
    super.initState();

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
        title: Text('My Cases',
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
        child: StreamBuilder<APIResponse<CaseTypeListModel>>(
            stream: myCaseBloc.caseListStream,
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
                        if (caseList.length > 0) {
                          return myCasesView();
                        }
                      }
                    }
                    break;

                  case Status.Done:
                    {
                      if (currentPage == 1) {
                        caseList.clear();
                      }

                      if (!isUpdateList) {
                        if (caseList.length <= totalCount) {
                          currentPage = currentPage + 1;
                        }

                        if (snapshot.data.data.data.length > 0) {
                          caseList = caseList + snapshot.data.data.data;
                          totalCount = snapshot.data.data.meta.count;
                        }
                      }

                      if (caseList.length > 0) {
                        return myCasesView();
                      } else {
                        return widgetNotAvailableData('Bid list not found.');
                      }
                      break;
                    }

                  case Status.Error:
                    return (caseList.length > 0) ? myCasesView() : Center();
                }
              } else {
                return showLoaderInList();
              }
            }),
        onRefresh: () async {
          pullToRefresh();
        });
  }

  Widget myCasesView() {
    return Container(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(10),
            left: ScreenUtil().setWidth(10),
            right: ScreenUtil().setWidth(10),
            bottom: ScreenUtil().setHeight(10)),
        child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: caseList.length,
            itemBuilder: (context, index) {
              return CaseInfoView(userType,
                  caseInfo: caseList[index], status: CaseStatus.MyCase);
            }));
  }

  pullToRefresh() {
    isUpdateList = false;
    currentPage = 1;
    totalCount = 0;
    myCaseBloc
        .getMyCasesList({'currentPage': currentPage.toString(), 'limit': '5'});
  }

  loadMore() {
    if (caseList.length <= totalCount) {
      isUpdateList = false;
      myCaseBloc.getMyCasesList(
          {'currentPage': currentPage.toString(), 'limit': '5'});
    }
  }
}
