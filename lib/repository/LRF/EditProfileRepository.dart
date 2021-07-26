import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class EditProfileRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> editProfile(
      Map<String, dynamic> params, String file) async {
    List<String> files = [file];
    var response = await helper.postMultiFormData(
        APITag.editprofile, params, files, 'userProfile');
    return response;
  }
}
