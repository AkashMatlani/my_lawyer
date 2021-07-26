import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/LRF/SigninRepository.dart';
import 'package:my_lawyer/models/UserModel.dart';
import 'package:my_lawyer/utils/Constant.dart';

class SignInBloc {
  SignInRepository signInRepository;
  StreamController signInController;

  StreamSink<APIResponse<UserModel>> get signInSink => signInController.sink;

  Stream<APIResponse<UserModel>> get signInStream => signInController.stream;

  SignInBloc() {
    signInRepository = SignInRepository();
    signInController = StreamController<APIResponse<UserModel>>();
  }

  signInUser(Map<String, dynamic> params) async {
    signInSink.add(APIResponse.loading('Loading...'));

    try {
      var response = await signInRepository.signInUser(params);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        signInSink.add(APIResponse.error(response));
      } else {
        UserModel modelResponse = UserModel.fromJson(response);
        signInSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      signInSink.add(APIResponse.error({'message': error.toString()}));
    }
  }

  dispose() {
    signInController.close();
  }
}
