import 'dart:async';
import 'package:my_lawyer/models/LawyerDetailModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/AcceptProposalRepository.dart';
import 'package:my_lawyer/repository/Client/LawyerDetailRepository.dart';

class LawyerDetailBloc {
  Map<String, dynamic> params;

  LawyerDetailRepository lawyerDetailRepository;
  StreamController lawyerDetailController;

  StreamSink<APIResponse<LawyerDetailModel>> get lawyerDetailSink =>
      lawyerDetailController.sink;

  Stream<APIResponse<LawyerDetailModel>> get lawyerDetailStream =>
      lawyerDetailController.stream;

  LawyerDetailBloc() {
    lawyerDetailRepository = LawyerDetailRepository();
    lawyerDetailController = StreamController<APIResponse<LawyerDetailModel>>();
  }

  getLawyerDetail(Map<String, dynamic> params) async {
    lawyerDetailSink.add(APIResponse.loading('Loading...'));
    try {
      LawyerDetailModel response =
          await lawyerDetailRepository.getLawyerDetail(params);
      lawyerDetailSink.add(APIResponse.done(response));
    } catch (error) {
      lawyerDetailSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    lawyerDetailController.close();
  }
}
