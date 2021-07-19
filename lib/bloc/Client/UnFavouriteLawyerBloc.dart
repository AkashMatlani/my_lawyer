import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/FavouriteLawyerRepository.dart';
import 'package:my_lawyer/repository/Client/LikeLawyerRepository.dart';
import 'package:my_lawyer/repository/LRF/ForgotPwdRepository.dart';

class UnFavouriteLawyerBloc {
  FavouriteLawyerRepository favouriteLawyerRepository;
  StreamController favLawyerController;

  StreamSink<APIResponse<dynamic>> get unFavSink =>
      favLawyerController.sink;

  Stream<APIResponse<dynamic>> get unFavStream =>
      favLawyerController.stream;

  UnFavouriteLawyerBloc() {
    favouriteLawyerRepository = FavouriteLawyerRepository();
    favLawyerController = StreamController<APIResponse<dynamic>>.broadcast();
  }

  unFavLawyerProfile(Map<String, dynamic> params) async {
    unFavSink.add(APIResponse.loading('Loading...'));

    try {
      dynamic response = await favouriteLawyerRepository.unFavLawyer(params);
      unFavSink.add(APIResponse.done(response));
    } catch (error) {
      unFavSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    favLawyerController.close();
  }
}
