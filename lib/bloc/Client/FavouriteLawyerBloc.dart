import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/FavouriteLawyerRepository.dart';
import 'package:my_lawyer/repository/Client/LikeLawyerRepository.dart';
import 'package:my_lawyer/repository/LRF/ForgotPwdRepository.dart';

class FavouriteLawyerBloc {
  FavouriteLawyerRepository favouriteLawyerRepository;
  StreamController favLawyerController;

  StreamSink<APIResponse<dynamic>> get forgotPwdSink =>
      favLawyerController.sink;

  Stream<APIResponse<dynamic>> get forgotPwdStream =>
      favLawyerController.stream;

  FavouriteLawyerBloc() {
    favouriteLawyerRepository = FavouriteLawyerRepository();
    favLawyerController = StreamController<APIResponse<dynamic>>();
  }

  favLawyerProfile(Map<String, dynamic> params) async {
    forgotPwdSink.add(APIResponse.loading('Loading...'));

    try {
      dynamic response = await favouriteLawyerRepository.favLawyer(params);
      forgotPwdSink.add(APIResponse.done(response));
    } catch (error) {
      forgotPwdSink.add(APIResponse.error({'message':error.toString()}));
    }
  }

  dispose() {
    favLawyerController.close();
  }
}
