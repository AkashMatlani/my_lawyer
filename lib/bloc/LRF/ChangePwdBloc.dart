import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/LRF/ChangePwdRepository.dart';

class ChangePasswordBloc {

  ChangePasswordRepository changePasswordRepository;
  StreamController changePwdController;

  StreamSink<APIResponse<dynamic>> get changePwdSink => changePwdController.sink;
  Stream<APIResponse<dynamic>> get changePwdStream => changePwdController.stream;

  ChangePasswordBloc() {
    changePasswordRepository = ChangePasswordRepository();
    changePwdController = StreamController<APIResponse<dynamic>>.broadcast();
  }

  changePassword(Map<String, dynamic> params) async {
    changePwdSink.add(APIResponse.loading('processing...'));

    try {
      dynamic response = await changePasswordRepository.changePassword(params);
      changePwdSink.add(APIResponse.done(response));
    } catch (error) {
      changePwdSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    changePwdController.close();
  }
}