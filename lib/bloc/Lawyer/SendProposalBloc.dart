import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Lawyer/SendProposalRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

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
    sendProposalSink.add(APIResponse.loading('Loading...'));
    try {
      dynamic response =
          await sendProposalRepository.sendProposalToClient(params);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        sendProposalSink.add(APIResponse.error(response));
      } else {
        sendProposalSink.add(APIResponse.done(response));
      }
    } catch (error) {
      sendProposalSink.add(APIResponse.error({'message': error.toString()}));
    }
  }

  dispose() {
    sendProposalController.close();
  }
}
