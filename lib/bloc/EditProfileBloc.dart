import 'dart:async';
import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/EditProfileRepository.dart';

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
    StreamController<APIResponse<UserModel>>.broadcast();
  }

  editProfile(Map<String, dynamic> params) async {
    editProfileSink.add(APIResponse.loading('processing...'));

    try {
      UserModel response = await editProfileRepository.editProfile();
      editProfileSink.add(APIResponse.done(response));
    } catch (error) {
      editProfileSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    editProfileController.close();
  }
}