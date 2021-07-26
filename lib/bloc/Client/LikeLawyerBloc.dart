import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/LikeLawyerRepository.dart';
import 'package:my_lawyer/repository/LRF/ForgotPwdRepository.dart';

class LikeLawyerBloc {

  LikeLawyerRepository likeLawyerRepository;
  StreamController likeLawyerController;

  StreamSink<APIResponse<dynamic>> get forgotPwdSink =>
      likeLawyerController.sink;

  Stream<APIResponse<dynamic>> get forgotPwdStream =>
      likeLawyerController.stream;

  LikeLawyerBloc() {
    likeLawyerRepository = LikeLawyerRepository();
    likeLawyerController = StreamController<APIResponse<dynamic>>();
  }

  likeLawyerProfile(Map<String, dynamic> params) async {
    forgotPwdSink.add(APIResponse.loading('Loading...'));

    try {
      dynamic response = await likeLawyerRepository.likeLawyer(params);
      forgotPwdSink.add(APIResponse.done(response));
    } catch (error) {
      forgotPwdSink.add(APIResponse.error({'message':error.toString()}));
    }
  }

  dispose() {
    likeLawyerController.close();
  }
}