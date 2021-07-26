import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/LRF/ChangePwdRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

class ChangePasswordBloc {
  ChangePasswordRepository changePasswordRepository;
  StreamController changePwdController;

  StreamSink<APIResponse<dynamic>> get changePwdSink =>
      changePwdController.sink;

  Stream<APIResponse<dynamic>> get changePwdStream =>
      changePwdController.stream;

  ChangePasswordBloc() {
    changePasswordRepository = ChangePasswordRepository();
    changePwdController = StreamController<APIResponse<dynamic>>();
  }

  changePassword(Map<String, dynamic> params) async {
    changePwdSink.add(APIResponse.loading('Loading...'));

    try {
      var response = await changePasswordRepository.changePassword(params);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        changePwdSink.add(APIResponse.error(response));
      } else {
        changePwdSink.add(APIResponse.done(response));
      }
    } catch (error) {
      changePwdSink.add(APIResponse.error({'message': error.toString()}));
    }
  }

  dispose() {
    changePwdController.close();
  }
}
