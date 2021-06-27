import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/LRF/ForgotPwdRepository.dart';

class ForgotPwdBloc {

  ForgotPwdRepository forgotPwdRepository;
  StreamController forgotPwdController;

  StreamSink<APIResponse<dynamic>> get forgotPwdSink =>
      forgotPwdController.sink;

  Stream<APIResponse<dynamic>> get forgotPwdStream =>
      forgotPwdController.stream;

  ForgotPwdBloc() {
    forgotPwdRepository = ForgotPwdRepository();
    forgotPwdController = StreamController<APIResponse<dynamic>>.broadcast();
  }

  forgotPwd(String email) async {
    forgotPwdSink.add(APIResponse.loading('processing...'));

    try {
      dynamic response = await forgotPwdRepository.forgotPwd(email);
      forgotPwdSink.add(APIResponse.done(response));
    } catch (error) {
      forgotPwdSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    forgotPwdController.close();
  }
}