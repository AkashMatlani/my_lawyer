import 'package:my_lawyer/models/AdModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class AdListRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<AdListModel> getAdList() async {
    var response = await helper.get(APITag.adList);
    return AdListModel.fromJson(response);
  }
}
