import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class MyCaseRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> getCaseList(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.myCases, params);
    return response;
  }

  // Future<CaseTypeListModel> getCaseList(Map<String, dynamic> params) async {
  //   var response = await helper.post(APITag.myCases, params);
  //   return CaseTypeListModel.fromJson(response);
  // }
}
