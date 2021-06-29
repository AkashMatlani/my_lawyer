import 'package:my_lawyer/networking/APIRequest.dart';

class CountyRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> countyList() async {
    var response = await helper.get(APITag.countyList);
    return response;
  }
}