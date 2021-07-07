import 'dart:async';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Lawyer/CaseListRepository.dart';

class CaseListBloc {

  CaseListRepository caseListRepository;
  StreamController caseListController;

  StreamSink<APIResponse<CaseTypeListModel>> get caseListSink =>
      caseListController.sink;

  Stream<APIResponse<CaseTypeListModel>> get caseListStream =>
      caseListController.stream;

  CaseListBloc() {
    caseListRepository = CaseListRepository();
    caseListController = StreamController<APIResponse<CaseTypeListModel>>();
  }

  getCaseListByType(Map<String, dynamic> params) async {
    caseListSink.add(APIResponse.loading('Processing...'));
    try {
      CaseTypeListModel caseList = await caseListRepository.getCaseList(params);
      caseListSink.add(APIResponse.done(caseList));
    } catch (error) {
      caseListSink.add(APIResponse.error(error.toString()));
    }
  }
}