import 'package:my_lawyer/models/CaseListModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class CriminalRepository {

  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> getCriminalList() async {
    var response =  await helper.get(APITag.criminalList);
    return response;
  }
  //  Future<CaseListModel> getCriminalList() async {
  //   var response = await helper.get(APITag.criminalList);
  //   return CaseListModel.fromJson(response);
  // }
}