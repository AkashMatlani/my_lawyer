import 'package:my_lawyer/models/LawyerDetailModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class LawyerDetailRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<LawyerDetailModel> getLawyerDetail(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.lawyerDetail, params);
    return LawyerDetailModel.fromJson(response);
  }
}
