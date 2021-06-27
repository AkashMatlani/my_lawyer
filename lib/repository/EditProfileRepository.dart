import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class EditProfileRepository {

  APIRequestHelper helper = APIRequestHelper();

  Future<UserModel> editProfile() async {

    var response = await helper.postMultiFormData(APITag.editprofile, {});
    return UserModel.fromJson(response);
  }
}

