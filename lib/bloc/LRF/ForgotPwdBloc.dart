import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/LRF/ForgotPwdRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

class ForgotPwdBloc {
  ForgotPwdRepository forgotPwdRepository;
  StreamController forgotPwdController;

  StreamSink<APIResponse<dynamic>> get forgotPwdSink =>
      forgotPwdController.sink;

  Stream<APIResponse<dynamic>> get forgotPwdStream =>
      forgotPwdController.stream;

  ForgotPwdBloc() {
    forgotPwdRepository = ForgotPwdRepository();
    forgotPwdController = StreamController<APIResponse<dynamic>>();
  }

  forgotPwd(String email) async {
    forgotPwdSink.add(APIResponse.loading('Loading...'));

    try {
      var response = await forgotPwdRepository.forgotPwd(email);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        forgotPwdSink.add(APIResponse.error(response));
      } else {
        forgotPwdSink.add(APIResponse.done(response));
      }
    } catch (error) {
      forgotPwdSink.add(APIResponse.error({'message': error.toString()}));
    }
  }

  dispose() {
    forgotPwdController.close();
  }
}
