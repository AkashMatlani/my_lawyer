import 'package:my_lawyer/networking/APIRequest.dart';

class StateRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> stateList() async {
    var response = await helper.get(APITag.stateList);
    return response;
  }
}
