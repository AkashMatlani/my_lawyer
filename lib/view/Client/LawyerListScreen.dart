import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_lawyer/bloc/Client/AdListBloc.dart';
import 'package:my_lawyer/bloc/Client/LawyerListBloc.dart';
import 'package:my_lawyer/bloc/Client/LikeLawyerBloc.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/AdModel.dart';
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
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class LawyerListScreen extends StatefulWidget {
  int selectedSegmentOption = LawyerListType.Hire;

  LawyerListScreen(this.selectedSegmentOption);

  @override
  _LawyerListScreenState createState() => _LawyerListScreenState();
}

class _LawyerListScreenState extends State<LawyerListScreen> {
  int currentPage = 1;
  int totalCount = 0;
  bool isUpdatedList = false;

  List<LawyerDataModel> lawyerList = [];
  List<AdDataModel> adList = [];

  ScrollController scrollController = ScrollController();
  LawyerListBloc lawyerListBloc = LawyerListBloc();
  LikeLawyerBloc likeLawyerBloc = LikeLawyerBloc();
  AdListBloc adListBloc = AdListBloc();

  PageController pageController = PageController();
  final currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    // TODO: implement initState

    getAdList();
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
        children: [
          sliderSegementView(),
          if (adList.length > 0) advertisementView(),
          if (adList.length > 1) pageIndicatorView(),
          Expanded(child: lawyerListStreamBuilder())
        ],
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
          LawyerListType.Hire: Text(
            'Hire',
            style: appThemeTextStyle(16,
                fontWeight: FontWeight.w700,
                textColor: (widget.selectedSegmentOption == LawyerListType.Hire)
                    ? Colors.white
                    : Color.fromRGBO(137, 143, 170, 1)),
          ),
          LawyerListType.Save: Text('Save',
              style: appThemeTextStyle(16,
                  fontWeight: FontWeight.w700,
                  textColor:
                      (widget.selectedSegmentOption == LawyerListType.Save)
                          ? Colors.white
                          : Color.fromRGBO(137, 143, 170, 1)))
        },
        onValueChanged: (selectedValue) {
          setState(() {
            widget.selectedSegmentOption = selectedValue as int;
            pullToRefresh();
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
                    child: Image.network(
                      adList[index].adImg,
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          child: Center(
                              child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: AppColor.ColorRed,
                            ),
                          )),
                        );
                      },
                    )));
          },
          onPageChanged: (selectedIndex) {
            setState(() {
              currentPageNotifier.value = selectedIndex;
            });
          },
        ),
      ),
    );
  }

  Widget pageIndicatorView() {
    return Padding(
      padding: EdgeInsets.only(top: 7),
      child: CirclePageIndicator(
        currentPageNotifier: currentPageNotifier,
        itemCount: adList.length,
        dotColor: AppColor.ColorDarkGray,
        selectedDotColor: AppColor.ColorRed,
        dotSpacing: 3,
        size: ScreenUtil().setWidth(10),
      ),
    );
  }

  Widget lawyerListStreamBuilder() {
    return RefreshIndicator(
        backgroundColor: AppColor.ColorRed,
        color: Colors.white,
        child: StreamBuilder<APIResponse<LawyerListModel>>(
            stream: lawyerListBloc.lawyerListStream,
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
                        if (lawyerList.length > 0) {
                          return lawyerListing();
                        }
                      }
                    }
                    break;

                  case Status.Done:
                    {
                      if (currentPage == 1) {
                        lawyerList.clear();
                      }

                      if (!isUpdatedList) {
                        if (snapshot.data.data.data.length > 0) {
                          lawyerList = lawyerList + snapshot.data.data.data;
                          totalCount = snapshot.data.data.meta.count;
                        }

                        if (lawyerList.length <= totalCount) {
                          currentPage = currentPage + 1;
                        }
                      }

                      if (lawyerList.length > 0) {
                        return lawyerListing();
                      } else {
                        return widgetNotAvailableData(
                            'Case not found for selected type.');
                      }
                      break;
                    }

                  case Status.Error:
                    return (lawyerList.length > 0) ?  lawyerListing() : Center();
                }
              } else {
                return showLoaderInList();
              }
            }),
        onRefresh: () async {
          pullToRefresh();
        });
  }

  Widget lawyerListing() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: lawyerList.length,
          itemBuilder: (context, index) {
            return LawyerListInfoView(lawyerList[index], index, true,
                (index, lawyerInfo, isFav) {
              setState(() {
                isUpdatedList = true;

                if (isFav) {
                  if (!lawyerInfo.isFav) {
                    if (lawyerList.length > 0) lawyerList.removeAt(index);
                  } else {
                    lawyerList[index] = lawyerInfo;
                  }
                }
              });
            }); //lawyerInfoView(lawyerList[index], index);
          }),
    );
  }

  pullToRefresh() {
    currentPage = 1;
    totalCount = 0;
    getLawyerListByType();
  }

  loadMore() {
    if (lawyerList.length <= totalCount) {
      getLawyerListByType();
    }
  }

  getLawyerListByType() {
    isUpdatedList = false;

    Map<String, dynamic> params = {
      'type': widget.selectedSegmentOption.toString(),
      'currentPage': currentPage.toString(),
      'limit': '5'
    };

    lawyerListBloc.getLawyerList(params);
  }

  getAdList() {
    adListBloc.getAdList();

    adListBloc.adListStream.listen((snapshot) {
      switch (snapshot.status) {
        case Status.Loading:
          break;

        case Status.Done:
          setState(() {
            adList = snapshot.data.data;
          });

          break;

        case Status.Error:
          return Center();

          break;
      }
    });
  }
}
