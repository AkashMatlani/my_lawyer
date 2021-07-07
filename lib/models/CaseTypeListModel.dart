import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CaseTypeListModel {
  List<CaseDataModel> data;
  CaseMetaModel meta;

  CaseTypeListModel({this.data, this.meta});

  CaseTypeListModel.fromJson(dynamic json) {
    data = [];

    List<dynamic> jsonList = json['data'];
    jsonList.forEach((item) {
      data.add(CaseDataModel.fromJson(item));
    });

    meta = CaseMetaModel.fromJson(json['meta']);
  }
}

class CaseDataModel {
  int id;
  int clientId;
  String userName;
  String userProfile;
  String caseType;
  String amount;

  CaseDataModel(
      {this.id, this.clientId, this.userName, this.userProfile, this.caseType, this.amount});

  factory CaseDataModel.fromJson(Map<String, dynamic> data) {
    return CaseDataModel(
      id: data['id'],
      clientId: data['clientId'],
      userName: data['userName'],
      userProfile: data['userProfile'],
      caseType: data['caseType'],
      amount: (data['amount'] == 0) ? 'Not Bid Yet' : data['amount'],
    );
  }
}

class CaseMetaModel {
  int count;
  int status;

  CaseMetaModel({this.count, this.status});

  factory CaseMetaModel.fromJson(Map<String, dynamic> meta) {
    return CaseMetaModel(count: meta['count'], status: meta['status']);
  }
}
