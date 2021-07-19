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
  int caseId;
  int clientId;
  String userName;
  String userProfile;
  String caseType;
  String amount;

  CaseDataModel(
      {this.caseId,
      this.clientId,
      this.userName,
      this.userProfile,
      this.caseType,
      this.amount});

  factory CaseDataModel.fromJson(Map<String, dynamic> data) {
    return CaseDataModel(
      caseId: data['caseId'],
      clientId: data['userId'],
      userName: data['userName'],
      userProfile: data['userProfile'],
      caseType: data['caseType'],
      amount: (data['amount'] == 0) ||
              (data['amount'] == null) ||
              (data['amount'] == '')
          ? 'Not Bid Yet'
          : r'$' + data['amount'],
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
