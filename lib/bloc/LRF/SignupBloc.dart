import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/LRF/SignupRepository.dart';
import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/utils/Constant.dart';

class SignUpBloc {
  SignUpRespository signUpRespository;
  StreamController signUpController;

  StreamSink<APIResponse<UserModel>> get signUpSink => signUpController.sink;

  Stream<APIResponse<UserModel>> get signUpStream => signUpController.stream;

  SignUpBloc() {
    signUpRespository = SignUpRespository();
    signUpController = StreamController<APIResponse<UserModel>>();
  }

  signUpUser(Map<String, dynamic> params) async {
    signUpSink.add(APIResponse.loading('Loading...'));

    try {
      var response = await signUpRespository.signUp(params);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        signUpSink.add(APIResponse.error(response));
      } else {
        UserModel modelResponse = UserModel.fromJson(response);
        signUpSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      signUpSink.add(APIResponse.error({'message': error.toString()}));
    }
  }

  dispose() {
    signUpController.close();
  }
}
