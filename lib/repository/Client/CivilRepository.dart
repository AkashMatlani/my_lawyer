import 'package:my_lawyer/models/CaseListModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class CivilRepository {

  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> getCivilList() async {
    var response = await helper.get(APITag.civilList);
    return response;
  }

  // Future<CaseListModel> getCivilList() async {
  //   var response = await helper.get(APITag.civilList);
  //   return CaseListModel.fromJson(response);
  // }
}