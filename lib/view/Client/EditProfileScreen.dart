import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppMessages.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_lawyer/utils/ImagePickerView.dart';
import 'package:my_lawyer/utils/LoadingView.dart';
import 'package:my_lawyer/view/Client/LawyerListScreen.dart';
import 'package:my_lawyer/view/Lawyer/SearchCaseScreen.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';
import 'dart:io';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_lawyer/bloc/LRF/EditProfileBloc.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var txtUserNameController = TextEditingController();
  var txtEmailController = TextEditingController();
  var txtAboutController = TextEditingController();

  EditProfileBloc editProfileBloc;
  File pickedImgFile;
  var userInfo;

  @override
  initState() {
    editProfileBloc = EditProfileBloc();

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
        title: Text('Edit Profile',
            style: appThemeTextStyle(20,
                fontWeight: FontWeight.w600, textColor: Colors.black)),
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
          child: GenericButton()
              .appThemeButton('Submit', 16, Colors.white, FontWeight.w700, () {
            _pressedOnSubmit();
          }, borderRadius: 8)),
    );
  }

  _pressedOnSubmit() {
    if (pickedImgFile == null) {
      AlertView().showAlert(Messages.CUploadImage, context);
      return;
    }

    Map<String, dynamic> params = {'userType': userInfo['userType'].toString()};

    if (userInfo['userType'] == UserType.Lawyer)
      params['about'] = txtAboutController.text;

    LoadingView().showLoaderWithTitle(true, context);
    editProfileBloc.editProfile(params, pickedImgFile.path);

    editProfileBloc.editProfileStream.listen((snapshot) {
      switch (snapshot.status) {
        case Status.Loading:
          return LoadingView(loadingMessage: snapshot.message);

        case Status.Done:
          LoadingView().showLoaderWithTitle(false, context);

          if ((snapshot.data.meta as UserMetaModel).status == 1) {
            //...Redirect on Home Screen

            print('SuccessFull');
            UserInfoModel userInfo = snapshot.data.data;
            storeUserInfo((snapshot.data.meta as UserMetaModel).token, {
              'userName': userInfo.userName,
              'userType': userInfo.userType,
              'userId': userInfo.userId,
              'userProfile': userInfo.userProfile,
              'signInType': userInfo.signInType,
              'email': userInfo.email,
              'about': userInfo.about
            });

            if (userInfo.userType == UserType.User) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LawyerListScreen()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchCasesScreen()));
            }
          } else {
            AlertView().showAlertView(
                context,
                (snapshot.data.meta as UserMetaModel).message,
                () => {Navigator.of(context).pop()});
          }
          break;

        case Status.Error:
          LoadingView().showLoaderWithTitle(false, context);
          AlertView().showAlertView(
              context, snapshot.message, () => {Navigator.of(context).pop()});
          break;
      }
    });
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
