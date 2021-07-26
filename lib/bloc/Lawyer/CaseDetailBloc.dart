import 'dart:async';
import 'package:my_lawyer/models/CaseDetailModel.dart';
import 'package:my_lawyer/models/LawyerDetailModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/AcceptProposalRepository.dart';
import 'package:my_lawyer/repository/Client/LawyerDetailRepository.dart';
import 'package:my_lawyer/repository/Lawyer/CaseDetailRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

class CaseDetailBloc {
  CaseDetailRepository caseDetailRepository;
  StreamController caseDetailController;

  StreamSink<APIResponse<CaseDetailModel>> get caseDetailSink =>
      caseDetailController.sink;

  Stream<APIResponse<CaseDetailModel>> get caseDetailStream =>
      caseDetailController.stream;

  CaseDetailBloc() {
    caseDetailRepository = CaseDetailRepository();
    caseDetailController = StreamController<APIResponse<CaseDetailModel>>();
  }

  getCaseDetail(int caseId) async {
    caseDetailSink.add(APIResponse.loading('Loading...'));
    try {
      var response = await caseDetailRepository.getCaseDetail(caseId);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        caseDetailSink.add(APIResponse.error(response));
      } else {
        CaseDetailModel modelResponse = CaseDetailModel.fromJson(response['data']);
        caseDetailSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      caseDetailSink.add(APIResponse.error({'message':error.toString()}));
    }
  }

  dispose() {
    caseDetailController.close();
  }
}
