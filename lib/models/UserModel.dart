import 'dart:async';
import 'dart:convert';

class UserInfoModel {
  int userId;
  String userName;
  String email;
  int userType;
  int signInTye;
  String userProfile;

  UserInfoModel(this.userId, this.userName, this.userProfile, this.userType,
      this.signInTye, this.email);

  factory UserInfoModel.fromJson(Map<String, dynamic> data) {
    return UserInfoModel(data['userId'], data['userName'], data['userProfile'],
        data['userType'], data['signInType'], data['email']);
  }
}

class UserMetaModel {
  String token;
  int status;

  UserMetaModel(this.token, this.status);

  factory UserMetaModel.fromJson(Map<String, dynamic> meta) {
    return UserMetaModel(meta['token'], meta['status']);
  }
}

class UserModel {
  UserInfoModel data;
  UserMetaModel meta;

  UserModel(this.data, this.meta);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(json['data'], json['meta']);
  }
}
