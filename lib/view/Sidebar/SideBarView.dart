import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/main.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/CommonStuff.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/view/Client/ChangePwdScreen.dart';
import 'package:my_lawyer/view/Client/Create%20Case/CreateCaseScreen.dart';
import 'package:my_lawyer/view/Client/EditProfileScreen.dart';
import 'package:my_lawyer/view/LRF/SigninScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBarView extends StatefulWidget {
  @override
  _SideBarViewState createState() => _SideBarViewState();
}

class _SideBarViewState extends State<SideBarView> {
  var userInfo;
  var arrMenuList;

  @override
  initState() {
    SharedPreferences.getInstance().then((prefs) {
      var userInfoStr = prefs.getString(UserPrefernces.UserInfo);

      var menuListClient = [
        {
          'img': 'images/Sidebar/ic_hire_lawyer.svg',
          'name': SideMenuOption.HireLawyer
        },
        {
          'img': 'images/Sidebar/ic_save.svg',
          'name': SideMenuOption.SavedCases
        },
        {
          'img': 'images/Sidebar/ic_view_bid.svg',
          'name': SideMenuOption.ViewBids
        },
        {
          'img': 'images/Sidebar/ic_create_case.svg',
          'name': SideMenuOption.CreateNewCase
        },
        {
          'img': 'images/Sidebar/ic_create_case.svg',
          'name': SideMenuOption.EditProfile
        },
        {
          'img': 'images/Sidebar/ic_create_case.svg',
          'name': SideMenuOption.ChangePassword
        }
      ];

      var menuListCSocialLogin = [
        {
          'img': 'images/Sidebar/ic_hire_lawyer.svg',
          'name': SideMenuOption.HireLawyer
        },
        {
          'img': 'images/Sidebar/ic_save.svg',
          'name': SideMenuOption.SavedCases
        },
        {'img': 'images/Sidebar/ic_view_bid', 'name': SideMenuOption.ViewBids},
        {
          'img': 'images/Sidebar/ic_create_case.svg',
          'name': SideMenuOption.CreateNewCase
        },
        {
          'img': 'images/Sidebar/ic_create_case.svg',
          'name': SideMenuOption.EditProfile
        },
      ];

      var menuListLawyer = [
        {
          'img': 'images/Sidebar/ic_create_case.svg',
          'name': SideMenuOption.SearchCases
        },
        {
          'img': 'images/Sidebar/ic_create_case.svg',
          'name': SideMenuOption.EditProfile
        },
        {
          'img': 'images/Sidebar/ic_create_case.svg',
          'name': SideMenuOption.ChangePassword
        }
      ];

      var menuListLSocialLogin = [
        {
          'img': 'images/Sidebar/ic_create_case.svg',
          'name': SideMenuOption.SearchCases
        },
        {
          'img': 'images/Sidebar/ic_create_case.svg',
          'name': SideMenuOption.EditProfile
        },
      ];

      setState(() {
        userInfo = json.decode(userInfoStr);
        arrMenuList = (userInfo['userType'] == UserType.User)
            ? (userInfo['signInType'] == SignInType.Normal)
                ? menuListClient
                : menuListCSocialLogin
            : (userInfo['signInType'] == SignInType.Normal)
                ? menuListLawyer
                : menuListLSocialLogin;
      });
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return sideMenu();
  }

  Widget sideMenu() {
    return Drawer(
      child: Column(children: [
        DrawerHeader(
          padding: EdgeInsets.all(0.0),
          child: drawerHeader(),
          decoration: BoxDecoration(
              color: AppColor.ColorYellowSideMenu,
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(54))),
        ),
        for (Map menuInfo in arrMenuList)
          ListTile(
            title: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(15),
                      right: ScreenUtil().setWidth(15)),
                  child: SvgPicture.asset(menuInfo['img']),
                ),
                Text(
                  menuInfo['name'],
                  style: appThemeTextStyle(16, textColor: Colors.black),
                )
              ],
            ),
            onTap: () {
              switch (menuInfo['name']) {
                case SideMenuOption.HireLawyer:
                  break;
                case SideMenuOption.SavedCases:
                  break;

                case SideMenuOption.CreateNewCase:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateCaseScreen()));

                  break;

                case SideMenuOption.ViewBids:
                  break;

                case SideMenuOption.EditProfile:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()));
                  break;

                case SideMenuOption.ChangePassword:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePwdScreen()));
                  break;

                case SideMenuOption.SearchCases:
                  break;
              }
            },
          ),
        Spacer(),
        logout()
      ]),
    );
  }

  Widget drawerHeader() {
    return Container(
      height: ScreenUtil().setHeight(147),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('images/Sidebar/ic_close.svg'),
          ),
          Row(
            children: [userProfile(), userName()],
          )
        ],
      ),
    );
  }

  Widget userProfile() {
    return Padding(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
        child: Container(
            width: ScreenUtil().setWidth(72),
            height: ScreenUtil().setHeight(72),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/Sidebar/ic_oval.png')),
            ),
            child: Padding(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(72) / 2),
                    child: (userInfo['userProfile'] == null)
                        ? Image(
                            image: AssetImage('images/Client/ic_profile.jpeg'),
                          )
                        : Image.network(userInfo['userProfile'])))));
  }

  Widget userName() {
    return Padding(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(19)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              userInfo['userName'] ?? '',
              style: appThemeTextStyle(16,
                  fontWeight: FontWeight.w600, textColor: Colors.black),
            ),
          ),
          Text(
            'Columbus',
            style: appThemeTextStyle(14,
                fontWeight: FontWeight.w400, textColor: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget logout() {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: ListTile(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(15),
                  right: ScreenUtil().setWidth(15)),
              child: SvgPicture.asset('images/Sidebar/ic_logout.svg'),
            ),
            Text(
              'Logout',
              style: appThemeTextStyle(16, textColor: Colors.black),
            )
          ],
        ),
        onTap: () {
          logOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SignInScreen(0)));
        },
      ),
    );
  }
}
