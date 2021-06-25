import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/SignupRepository.dart';
import 'package:my_lawyer/models/UserModel.dart';

class SignUpBloc {
  SignUpRespository signUpRespository;
  StreamController signUpController;

  StreamSink<APIResponse<UserModel>> get signUpSink => signUpController.sink;
  Stream<APIResponse<UserModel>> get signUpStream => signUpController.stream;

  SignUpBloc() {
    signUpRespository = SignUpRespository();
    signUpController = StreamController<APIResponse<UserModel>>.broadcast();
  }

  signUpUser(Map<String, dynamic> params) async {
    signUpSink.add(APIResponse.loading('Processing...'));

    try {
      UserModel response = await signUpRespository.signUp(params);
      signUpSink.add(APIResponse.done(response));
    } catch (error) {
      signUpSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    signUpController.close();
  }
}
