import 'package:my_lawyer/networking/APIRequest.dart';

class AcceptProposalRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> acceptBidProposal(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.acceptBid, params);
    return response;
  }
}
