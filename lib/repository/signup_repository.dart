import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/networking/api_request_helper.dart';

class SignUpRespository {

   APIRequestHelper helper = APIRequestHelper();

  Future<UserModel> signUp(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.signUp, params);
    return UserModel.fromJson(response);
  }
}
