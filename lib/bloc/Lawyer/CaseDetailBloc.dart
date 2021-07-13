import 'dart:async';
import 'package:my_lawyer/models/CaseDetailModel.dart';
import 'package:my_lawyer/models/LawyerDetailModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/AcceptProposalRepository.dart';
import 'package:my_lawyer/repository/Client/LawyerDetailRepository.dart';
import 'package:my_lawyer/repository/Lawyer/CaseDetailRepository.dart';

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
      CaseDetailModel response =
          await caseDetailRepository.getCaseDetail(caseId);
      caseDetailSink.add(APIResponse.done(response));
    } catch (error) {
      caseDetailSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    caseDetailController.close();
  }
}
