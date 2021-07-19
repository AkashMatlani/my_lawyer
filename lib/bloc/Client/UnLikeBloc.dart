import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/LikeLawyerRepository.dart';
import 'package:my_lawyer/repository/LRF/ForgotPwdRepository.dart';

class UnLikeLawyerBloc {

  LikeLawyerRepository likeLawyerRepository;
  StreamController UnLikeLawyerController;

  StreamSink<APIResponse<dynamic>> get unLikeSink =>
      UnLikeLawyerController.sink;

  Stream<APIResponse<dynamic>> get unLikeStream =>
      UnLikeLawyerController.stream;

  UnLikeLawyerBloc() {
    likeLawyerRepository = LikeLawyerRepository();
    UnLikeLawyerController = StreamController<APIResponse<dynamic>>.broadcast();
  }

  unLikeLawyerProfile(Map<String, dynamic> params) async {
    unLikeSink.add(APIResponse.loading('Loading...'));

    try {
      dynamic response = await likeLawyerRepository.unLikeLawyer(params);
      unLikeSink.add(APIResponse.done(response));
    } catch (error) {
      unLikeSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    UnLikeLawyerController.close();
  }
}