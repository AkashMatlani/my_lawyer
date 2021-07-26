import 'package:my_lawyer/models/BidListModel.dart';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class MyBidRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> getMyBidList(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.myBidding, params);
    return response;
  }

// Future<BidListModel> getMyBidList(Map<String, dynamic> params) async {
//   var response = await helper.post(APITag.myBidding, params);
//   return BidListModel.fromJson(response);
// }
}
