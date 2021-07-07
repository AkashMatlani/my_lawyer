import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Lawyer/SendProposalRepository.dart';

class SendProposalBloc {

  SendProposalRepository sendProposalRepository;
  StreamController sendProposalController;

  StreamSink<APIResponse<dynamic>> get sendProposalSink =>
      sendProposalController.sink;

  Stream<APIResponse<dynamic>> get sendProposalStream =>
      sendProposalController.stream;

  SendProposalBloc() {
    sendProposalRepository = SendProposalRepository();
    sendProposalController = StreamController<APIResponse<dynamic>>();
  }

  sendProposalToClient(Map<String, dynamic> params) async {
    sendProposalSink.add(APIResponse.loading('Processing...'));
    try {
      dynamic response = await sendProposalRepository.sendProposalToClient(
          params);
      sendProposalSink.add(APIResponse.done(response));
    } catch (error) {
      sendProposalSink.add(APIResponse.error(error.toString()));
    }
  }

}