import 'package:my_lawyer/networking/APIRequest.dart';

class ChangePasswordRepository {

  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> changePassword(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.changePassword, params);
    return response;
  }
}