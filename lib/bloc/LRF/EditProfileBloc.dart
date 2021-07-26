import 'dart:async';
import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/LRF/EditProfileRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

class EditProfileBloc {
  EditProfileRepository editProfileRepository;
  StreamController editProfileController;

  StreamSink<APIResponse<UserModel>> get editProfileSink =>
      editProfileController.sink;

  Stream<APIResponse<UserModel>> get editProfileStream =>
      editProfileController.stream;

  EditProfileBloc() {
    editProfileRepository = EditProfileRepository();
    editProfileController =
        StreamController<APIResponse<UserModel>>();
  }

  editProfile(Map<String, dynamic> params, String file) async {
    editProfileSink.add(APIResponse.loading('Loading...'));

    try {
      var response = await editProfileRepository.editProfile(params, file);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        editProfileSink.add(APIResponse.error(response));
      } else {
        UserModel modelResponse = UserModel.fromJson(response);
        editProfileSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      editProfileSink.add(APIResponse.error({'message': error.toString()}));
    }
  }

  dispose() {
    editProfileController.close();
  }
}
