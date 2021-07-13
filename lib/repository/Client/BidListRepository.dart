import 'package:my_lawyer/models/BidListModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';

class BidListRepository {

  APIRequestHelper helper = APIRequestHelper();

  Future<LawyerListModel> getBidList(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.viewBids, params);
    return LawyerListModel.fromJson(response);
  }
}