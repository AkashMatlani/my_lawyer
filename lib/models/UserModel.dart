import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserInfoModel {
  int userId;
  String userName;
  String email;
  int userType;
  int signInType;
  String userProfile;
  String about;

  UserInfoModel(
      {this.userId,
      this.userName,
      this.userProfile,
      this.userType,
      this.signInType,
      this.email, this.about});

  factory UserInfoModel.fromJson(Map<String, dynamic> data) {
    return UserInfoModel(
        userId: data['userId'],
        userName: data['userName'],
        userProfile: data['userProfile'],
        userType: data['userType'],
        signInType: data['signInType'],
        email: data['email'],
    about: data['about']);
  }

  Map<String, dynamic> defaultUserData = {
    'userId': 0,
    'userName': '',
    'email': '',
    'userType': 0,
    'signInType': 0,
    'userProfile': '',
    'about': ''
  };
}

class UserMetaModel {
  String token;
  int status;
  String message;

  UserMetaModel({this.token, this.status, this.message});

  factory UserMetaModel.fromJson(Map<String, dynamic> meta) {
    return UserMetaModel(
        token: meta['token'], status: meta['status'], message: meta['message']);
  }
}

class UserModel {
  dynamic data;
  dynamic meta;

  UserModel({this.data, this.meta});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        data: (json['data'] == null)
            ? UserInfoModel().defaultUserData
            : UserInfoModel.fromJson(json['data']),
        meta: UserMetaModel.fromJson(json['meta']));
  }
}

storeUserInfo(String token, Map<String, dynamic> userInfo) async {
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  sharedPreferences.setString('UserToken', token);
  sharedPreferences.setString('UserInfo', json.encode(userInfo));
}