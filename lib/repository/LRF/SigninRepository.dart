import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class SignInRepository {

  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> signInUser(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.signIn, params);
    return response;
  }

  // Future<UserModel> signInUser(Map<String, dynamic> params) async {
  //   var response = await helper.post(APITag.signIn, params);
  //   return UserModel.fromJson(response);
  // }
}