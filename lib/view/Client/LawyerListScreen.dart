import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_lawyer/bloc/Client/LawyerListBloc.dart';
import 'package:my_lawyer/bloc/Client/LikeLawyerBloc.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
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
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';

class LawyerListScreen extends StatefulWidget {
  int selectedSegmentOption = LawyerListType.Hire;

  LawyerListScreen(this.selectedSegmentOption);

  @override
  _LawyerListScreenState createState() => _LawyerListScreenState();
}

class _LawyerListScreenState extends State<LawyerListScreen> {
  var adList = [
    'images/Client/temp_ad1.jpeg',
    'images/Client/temp_ad2.jpeg',
    'images/Client/temp_ad3.jpeg',
    'images/Client/temp_ad4.jpeg'
  ];

  int currentPage = 1;
  int totalCount = 0;
  List<LawyerDataModel> lawyerList = [];

  ScrollController scrollController = ScrollController();
  LawyerListBloc lawyerListBloc = LawyerListBloc();
  LikeLawyerBloc likeLawyerBloc = LikeLawyerBloc();

  @override
  void initState() {
    // TODO: implement initState
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
          advertisementView(),
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
                      child: Image(
                        image: AssetImage(adList[index]),
                        fit: BoxFit.fill,
                      ),
                    ));
              })),
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

                      if (lawyerList.length <= totalCount) {
                        currentPage = currentPage + 1;
                      }

                      if (snapshot.data.data.data.length > 0) {
                        lawyerList = lawyerList + snapshot.data.data.data;
                        totalCount = snapshot.data.data.meta.count;
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

  Widget lawyerListing() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: ListView.builder(
          controller: scrollController,
          itemCount: lawyerList.length,
          itemBuilder: (context, index) {
            return LawyerListInfoView(lawyerList[index], index, true,
                (index, lawyerInfo) {
              setState(() {
                lawyerList[index] = lawyerInfo;
              });
            }); //lawyerInfoView(lawyerList[index], index);
          }),
    );
  }

  // Widget lawyerInfoView(LawyerDataModel lawyerInfo, int index) {
  //   return Padding(
  //       padding: EdgeInsets.only(
  //         top: ScreenUtil().setHeight(10),
  //         bottom: ScreenUtil().setHeight(10),
  //       ),
  //       child: Container(
  //         width: screenWidth(context),
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             border: Border.all(color: AppColor.ColorBorder, width: 0.5),
  //             borderRadius: BorderRadius.circular(8),
  //             boxShadow: [
  //               BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.11), blurRadius: 2)
  //             ]),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 lawyerProfilePicView(lawyerInfo.userProfile),
  //                 lawyerNameAndAbout(lawyerInfo.about, lawyerInfo.lawyerName),
  //                 favoriteBtn(lawyerInfo.isFav, index),
  //               ],
  //             ),
  //             bidRateAndLike(lawyerInfo.bidAmount, lawyerInfo.isLike,
  //                 lawyerInfo.likeCount, index),
  //             viewDetailBtn(lawyerInfo)
  //           ],
  //         ),
  //       ));
  // }
  //
  // Widget lawyerProfilePicView(String userProfile) {
  //   return Padding(
  //     padding: EdgeInsets.only(
  //         top: ScreenUtil().setHeight(10), left: ScreenUtil().setHeight(10)),
  //     child: ClipRRect(
  //         borderRadius: BorderRadius.circular(ScreenUtil().setHeight(60) / 2),
  //         child: (userProfile == '')
  //             ? Image(
  //                 image: AssetImage(AppImage.CProfileImg),
  //                 fit: BoxFit.fill,
  //                 width: ScreenUtil().setHeight(60),
  //                 height: ScreenUtil().setHeight(60),
  //               )
  //             : ImageNetwork()
  //                 .loadNetworkImage(userProfile, ScreenUtil().setHeight(60))),
  //   );
  // }
  //
  // Widget lawyerNameAndAbout(String about, String name) {
  //   return Expanded(
  //       child: Padding(
  //     padding: EdgeInsets.only(
  //         left: ScreenUtil().setWidth(13),
  //         top: ScreenUtil().setHeight(13),
  //         right: ScreenUtil().setWidth(13)),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           name,
  //           style: appThemeTextStyle(16,
  //               fontWeight: FontWeight.w700, textColor: Colors.black),
  //         ),
  //         Text(
  //           about,
  //           style: TextStyle(),
  //         ),
  //       ],
  //     ),
  //   ));
  // }
  //
  // Widget favoriteBtn(bool isFav, int index) {
  //   return InkWell(
  //     child: SvgPicture.asset(
  //       'images/Client/ic_fav.svg',
  //       color: isFav ? AppColor.ColorRed : Colors.transparent,
  //     ),
  //     onTap: () {
  //       _pressedOnFavourite(lawyerList[index], index);
  //     },
  //   );
  // }
  //
  // Widget bidRateAndLike(String amount, bool isLike, int likeCount, int index) {
  //   return Padding(
  //     padding: EdgeInsets.only(
  //         left: ScreenUtil().setWidth(17),
  //         right: ScreenUtil().setWidth(17),
  //         top: ScreenUtil().setHeight(12)),
  //     child: Container(
  //       width: screenWidth(context),
  //       height: ScreenUtil().setHeight(47),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         border: Border.all(color: AppColor.ColorBorder, width: 0.5),
  //         borderRadius: BorderRadius.circular(6),
  //       ),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             flex: 1,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'Bid Rate',
  //                   style: appThemeTextStyle(13, textColor: Colors.black),
  //                 ),
  //                 Text(
  //                   '\$' + amount,
  //                   style: appThemeTextStyle(20,
  //                       textColor: Colors.black, fontWeight: FontWeight.w700),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             width: 1,
  //             height: ScreenUtil().setHeight(47),
  //             color: AppColor.ColorBorder,
  //           ),
  //           Expanded(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'Like',
  //                   style: appThemeTextStyle(13, textColor: Colors.black),
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     _pressedOnLike(lawyerList[index], index);
  //                   },
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       SizedBox(
  //                         width: 20,
  //                         height: 20,
  //                         child: Image(
  //                           image: AssetImage('images/Client/ic_like.png'),
  //                           color: isLike
  //                               ? AppColor.ColorRed
  //                               : AppColor.ColorLikeGray,
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(left: 5),
  //                         child: Text(
  //                           '$likeCount',
  //                           style: appThemeTextStyle(15,
  //                               textColor: Colors.black,
  //                               fontWeight: FontWeight.w700),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget viewDetailBtn(LawyerDataModel lawyerInfo) {
  //   return Padding(
  //     padding: EdgeInsets.only(
  //         top: ScreenUtil().setHeight(24),
  //         left: ScreenUtil().setWidth(16),
  //         right: ScreenUtil().setWidth(16),
  //         bottom: ScreenUtil().setHeight(16)),
  //     child: SizedBox(
  //         width: screenWidth(context),
  //         height: ScreenUtil().setHeight(38),
  //         child: GenericButton().appThemeButton(
  //             'View Detail', 16, Colors.white, FontWeight.w700, () {
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => LawyerDetailScreen(lawyerInfo.caseId, lawyerInfo.lawyerId)));
  //         }, borderRadius: 6)),
  //   );
  // }
  //
  // _pressedOnFavourite(LawyerDataModel lawyerInfo, int index) {
  //   var updatedLawyerInfo = lawyerInfo;
  //   updatedLawyerInfo.isFav = !updatedLawyerInfo.isFav;
  //
  //   setState(() {
  //     lawyerList[index] = updatedLawyerInfo;
  //   });
  //
  //   likeLawyerBloc.likeLawyerProfile({
  //     'lawyerId': updatedLawyerInfo.lawyerId,
  //     'isFavorite': updatedLawyerInfo.isLike
  //   });
  // }

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
    Map<String, dynamic> params = {
      'type': widget.selectedSegmentOption.toString(),
      'currentPage': currentPage.toString(),
      'limit': '5'
    };

    lawyerListBloc.getLawyerList(params);
  }

// _pressedOnLike(LawyerDataModel lawyerInfo, int index) {
//   var updatedLawyerInfo = lawyerInfo;
//   updatedLawyerInfo.isLike = !updatedLawyerInfo.isLike;
//   updatedLawyerInfo.likeCount = (updatedLawyerInfo.isLike)
//       ? updatedLawyerInfo.likeCount + 1
//       : updatedLawyerInfo.likeCount - 1;
//
//   setState(() {
//     lawyerList[index] = updatedLawyerInfo;
//   });
//
//   likeLawyerBloc.likeLawyerProfile({
//     'lawyerId': updatedLawyerInfo.lawyerId,
//     'isLike': updatedLawyerInfo.isLike
//   });
// }
}
