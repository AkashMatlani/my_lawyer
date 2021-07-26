import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/AcceptProposalRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

class AcceptBidProposalBloc {
  AcceptProposalRepository acceptProposalRepository;
  StreamController acceptBidController;

  StreamSink<APIResponse<dynamic>> get acceptBidSink =>
      acceptBidController.sink;

  Stream<APIResponse<dynamic>> get acceptBidStream =>
      acceptBidController.stream;

  AcceptBidProposalBloc() {
    acceptProposalRepository = AcceptProposalRepository();
    acceptBidController = StreamController<APIResponse<dynamic>>();
  }

  acceptBidProposal(Map<String, dynamic> params) async {
    acceptBidSink.add(APIResponse.loading('Loading...'));
    try {
      dynamic response =
          await acceptProposalRepository.acceptBidProposal(params);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        acceptBidSink.add(APIResponse.error(response));
      } else {
        acceptBidSink.add(APIResponse.done(response));
      }
    } catch (error) {
      acceptBidSink.add(APIResponse.error({'message': error.toString()}));
    }
  }

  dispose() {
    acceptBidController.close();
  }
}
