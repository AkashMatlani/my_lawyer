import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BidListModel {
  List<BidDataModel> data;
  BidMetaModel meta;

  BidListModel({this.data, this.meta});

  BidListModel.fromJson(dynamic json) {
    data = [];

    List<dynamic> jsonList = json['data'];
    jsonList.forEach((item) {
      data.add(BidDataModel.fromJson(item));
    });

    meta = BidMetaModel.fromJson(json['meta']);
  }
}

class BidDataModel {
  int caseId;
  int userId;
  String userName;
  String userProfile;
  String about;
  String bidAmount;
  bool isLike;
  bool isFav;
  int likeCount;
  String caseType;

  BidDataModel(
      {this.caseId,
      this.userId,
      this.userName,
      this.userProfile,
      this.about,
      this.bidAmount,
      this.isLike,
      this.isFav,
      this.likeCount,
      this.caseType});

  factory BidDataModel.fromJson(Map<String, dynamic> data) {
    return BidDataModel(
        caseId: data['caseId'],
        userId: data['userId'],
        userName: data['userName'],
        userProfile: data['userProfile'],
        about: data['about'],
        bidAmount: (data['bidAmount'] != null || data['bidAmount'] != "") ? r'$'+data['bidAmount'] : '',
        isLike: data['isLike'],
        isFav: data['isFav'],
        likeCount: data['likeCount'],
        caseType: data['caseType']);
  }
}

class BidMetaModel {
  int count;
  int status;

  BidMetaModel({this.count, this.status});

  factory BidMetaModel.fromJson(Map<String, dynamic> meta) {
    return BidMetaModel(count: meta['count'], status: meta['status']);
  }
}
