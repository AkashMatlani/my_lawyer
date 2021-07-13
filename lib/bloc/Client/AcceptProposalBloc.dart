import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/AcceptProposalRepository.dart';

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
      acceptBidSink.add(APIResponse.done(response));
    } catch (error) {
      acceptBidSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    acceptBidController.close();
  }
}
