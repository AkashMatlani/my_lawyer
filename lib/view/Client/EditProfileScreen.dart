import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_lawyer/utils/ImagePickerView.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';
import 'dart:io';
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var txtUserNameController = TextEditingController();
  var txtEmailController = TextEditingController();
  var txtAboutController = TextEditingController();

  File pickedImgFile;
  var userInfo;

  @override
  initState() {
    SharedPreferences.getInstance().then((prefs) {
      var userInfoStr = prefs.getString(UserPrefernces.UserInfo);

      setState(() {
        userInfo = json.decode(userInfoStr);
      });

      txtUserNameController.text = userInfo['userName'];
      txtEmailController.text = userInfo['email'];
      txtAboutController.text = userInfo['about'];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset('images/Sidebar/ic_burger.svg')),
        ),
      ),
      drawer: SideBarView(),
      body: editProfileView(),
    );
  }

  Widget editProfileView() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 24),
      child: Form(
          child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(children: [
          userProfile(),
          txtFieldUserName(),
          txtFieldEmail(),
          if (userInfo['userType'] == UserType.Lawyer) txtViewAbout(),
          submitBtn()
        ]),
      )),
    );
  }

  Widget userProfile() {
    return Center(
      child: InkWell(
        child: Column(
          children: [
            if (pickedImgFile == null)
              Image(
                image: AssetImage('images/Client/ic_profile.jpeg'),
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setHeight(100),
              )
            else
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(ScreenUtil().setWidth(100) / 2),
                child: Image.file(
                  pickedImgFile,
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(100),
                  fit: BoxFit.fill,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: 7, bottom: 10),
              child: Text(
                'Upload Pic',
                style: appThemeTextStyle(13, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
        onTap: () {
          ImagePickerView().showChooseImagePicker(
              context, onTap(ImageSource.gallery), onTap(ImageSource.camera));
        },
      ),
    );
  }

  Widget txtFieldUserName() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField(
            'User Name', TextInputType.name, txtUserNameController,
            prefixIcon: 'images/LRF/ic_user.svg',
            hasPrefixIcon: true,
            readOnly: true),
      ),
    );
  }

  Widget txtFieldEmail() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
      child: SizedBox(
        height: ScreenUtil().setHeight(52),
        child: appThemeTextField(
            'Email ID', TextInputType.emailAddress, txtEmailController,
            prefixIcon: 'images/LRF/ic_email.svg',
            hasPrefixIcon: true,
            readOnly: true),
      ),
    );
  }

  Widget txtViewAbout() {
    return Padding(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(12),
            bottom: ScreenUtil().setHeight(12)),
        child: appThemeTextField(
            'About YourSelf', TextInputType.name, txtAboutController,
            maxLines: 4,
            prefixIcon: 'images/LRF/ic_user.svg',
            bottomPaddingPrefixImg: 70,
            hasPrefixIcon: true));
  }

  Widget submitBtn() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
      child: SizedBox(
          width: screenWidth(context),
          height: ScreenUtil().setHeight(52),
          child: GenericButton().appThemeButton(
              'Submit', 16, Colors.white, FontWeight.w700, () {},
              borderRadius: 8)),
    );
  }

  Function onTap(ImageSource source) {
    return () {
      getPickImage(source);
    };
  }

  getPickImage(ImageSource source) {
    ImagePickerView().pickImage(source).then((value) => setState(() {
          if (value != null) {
            pickedImgFile = File(value.path);
          }
        }));
  }
}
