import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/LRF/SigninRepository.dart';
import 'package:my_lawyer/models/UserModel.dart';

class SignInBloc {

  SignInRepository signInRepository;
  StreamController signInController;

  StreamSink<APIResponse<UserModel>> get signInSink => signInController.sink;

  Stream<APIResponse<UserModel>> get signInStream => signInController.stream;

  SignInBloc() {
    signInRepository = SignInRepository();
    signInController = StreamController<APIResponse<UserModel>>.broadcast();
  }

  signInUser(Map<String, dynamic> params) async {
    signInSink.add(APIResponse.loading('Loading...'));

    try {
      UserModel response = await signInRepository.signInUser(params);
      signInSink.add(APIResponse.done(response));
    } catch (error) {
      signInSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    signInController.close();
  }
}