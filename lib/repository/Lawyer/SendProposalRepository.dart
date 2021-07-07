import 'package:my_lawyer/networking/APIRequest.dart';

class SendProposalRepository {
  
  APIRequestHelper helper = APIRequestHelper();
  
  Future<dynamic> sendProposalToClient(Map<String, dynamic> params) async {
    var response = await helper.post(APITag.sendProposal, params);
    return response;
} 
}