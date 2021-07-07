import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class LawyerListRepository {

  APIRequestHelper helper = APIRequestHelper();

  Future<LawyerListModel> getLawyerList(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.lawyerList, params);
    return LawyerListModel.fromJson(response);
  }
}