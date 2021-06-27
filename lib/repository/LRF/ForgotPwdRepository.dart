import 'package:my_lawyer/networking/APIRequest.dart';

class ForgotPwdRepository {
  
  APIRequestHelper helper = APIRequestHelper();
  
  Future<dynamic> forgotPwd(String email) async {
    
    var response = await helper.post(APITag.forgotPwd, {'email': email});
    return response;
  }
}