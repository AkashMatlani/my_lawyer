import 'package:my_lawyer/networking/APIRequest.dart';

class FavouriteLawyerRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> favLawyer(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.favLawyer, params);
    return response;
  }

  Future<dynamic> unFavLawyer(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.UnFavLawyer, params);
    return response;
  }
}
