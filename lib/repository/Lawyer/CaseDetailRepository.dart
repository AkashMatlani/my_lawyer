import 'package:flutter/material.dart';
import 'package:my_lawyer/models/CaseDetailModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class CaseDetailRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> getCaseDetail(int caseId) async {
    var response =
        await helper.post(APITag.caseDetail, {'caseId': caseId.toString()});
    return response;
  }

// Future<CaseDetailModel> getCaseDetail(int caseId) async {
//   var response = await helper.post(APITag.caseDetail, {'caseId': caseId.toString()});
//   return CaseDetailModel.fromJson(response['data']);
// }
}
