import 'package:my_lawyer/networking/APIRequest.dart';

class LikeLawyerRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> likeLawyer(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.isLike, params);
    return response;
  }

  Future<dynamic> unLikeLawyer(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.unLike, params);
    return response;
  }
}
