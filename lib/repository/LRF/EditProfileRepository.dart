import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class EditProfileRepository {

  APIRequestHelper helper = APIRequestHelper();

  Future<UserModel> editProfile(Map<String,dynamic> params, String file) async {

    var response = await helper.postMultiFormData(APITag.editprofile, params,file);
    return UserModel.fromJson(response);
  }
}

