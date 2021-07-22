import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/bloc/Lawyer/CaseListBloc.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/CommonWidgets.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/LoadingView.dart';
import 'package:my_lawyer/view/Lawyer/CaseInfoView.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchCasesScreen extends StatefulWidget {
  @override
  _SearchCasesScreenState createState() => _SearchCasesScreenState();
}

class _SearchCasesScreenState extends State<SearchCasesScreen> {
  int selectedCase = CaseType.Criminal;
  int userType = 0;
  int currentPage = 1;
  int totalCount = 0;
  bool isUpdate = false;

  List<CaseDataModel> caseList = [];

  ScrollController scrollController = ScrollController();
  CaseListBloc caseListBloc;

  @override
  initState() {
    SharedPreferences.getInstance().then((prefs) {
      var userInfoStr = prefs.getString(UserPrefernces.UserInfo);

      setState(() {
        var userInfo = json.decode(userInfoStr);
        userType = userInfo['userType'];
      });
    });

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    caseListBloc = CaseListBloc();
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
        title: Text('Search Case',
            style: appThemeTextStyle(20,
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
        children: [
          sliderSegementView(),
          Expanded(
            child: caseListStreamBuilder(),
          )
        ],
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
              CaseType.Criminal: Text(
                'Criminal',
                style: appThemeTextStyle(16,
                    fontWeight: FontWeight.w700,
                    textColor: (selectedCase == CaseType.Criminal)
                        ? Colors.white
                        : Color.fromRGBO(137, 143, 170, 1)),
              ),
              CaseType.Civil: Text('Civil',
                  style: appThemeTextStyle(16,
                      fontWeight: FontWeight.w700,
                      textColor: (selectedCase == CaseType.Civil)
                          ? Colors.white
                          : Color.fromRGBO(137, 143, 170, 1))),
              CaseType.Custom: Text('Custom',
                  style: appThemeTextStyle(16,
                      fontWeight: FontWeight.w700,
                      textColor: (selectedCase == CaseType.Custom)
                          ? Colors.white
                          : Color.fromRGBO(137, 143, 170, 1)))
            },
            onValueChanged: (selectedValue) {
              setState(() {
                selectedCase = selectedValue as int;
                pullToRefresh();
              });
            },
          ),
        ));
  }

  Widget caseListStreamBuilder() {
    return Container(
      child: StreamBuilder<APIResponse<CaseTypeListModel>>(
          stream: caseListBloc.caseListStream,
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
                        return searchCaseList();
                      }
                    }
                  }
                  break;

                case Status.Done:
                  {
                    if (currentPage == 1) {
                      caseList.clear();
                    }

                    if (isUpdate) {
                      if (snapshot.data.data.data.length > 0) {
                        caseList = caseList + snapshot.data.data.data;
                        totalCount = snapshot.data.data.meta.count;
                      }

                      if (caseList.length <= totalCount) {
                        currentPage = currentPage + 1;
                      }

                      isUpdate = false;
                    }

                    if (caseList.length > 0) {
                      return searchCaseList();
                    } else {
                      return widgetNotAvailableData(
                          'Case not found for selected type.');
                    }
                  }
                  break;

                case Status.Error:
                  AlertView()
                      .showAlertView(context, snapshot.data.message, () {});
              }
            } else {
              return showLoaderInList();
            }
          }),
    );
  }

  Widget searchCaseList() {
    return RefreshIndicator(
        backgroundColor: AppColor.ColorRed,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              itemCount: caseList.length,
              itemBuilder: (context, index) {
                return CaseInfoView(userType, caseInfo: caseList[index]);
              }),
        ),
        onRefresh: () async => pullToRefresh());
  }

  pullToRefresh() {
    currentPage = 1;
    totalCount = 0;
    getCaseListByType();
  }

  loadMore() {
    if (caseList.length <= totalCount) {
      getCaseListByType();
    }
  }

  getCaseListByType() {
    isUpdate = true;

    Map<String, dynamic> params = {
      'caseTypeId': selectedCase.toString(),
      'currentPage': currentPage.toString(),
      'limit': '5'
    };

    caseListBloc.getCaseListByType(params);
  }
}
