import 'dart:async';
import 'package:my_lawyer/models/LawyerDetailModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/AcceptProposalRepository.dart';
import 'package:my_lawyer/repository/Client/LawyerDetailRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

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
      var response = await lawyerDetailRepository.getLawyerDetail(params);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        lawyerDetailSink.add(APIResponse.error(response));
      } else {
        LawyerDetailModel modelResponse = LawyerDetailModel.fromJson(response);
        lawyerDetailSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      lawyerDetailSink.add(APIResponse.error({'message':error.toString()}));
    }
  }

  dispose() {
    lawyerDetailController.close();
  }
}
