import 'dart:async';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/MyCaseRepository.dart';
import 'package:my_lawyer/repository/Lawyer/CaseListRepository.dart';

class MyCaseBloc {

  MyCaseRepository myCaseRepository;
  StreamController caseListController;

  StreamSink<APIResponse<CaseTypeListModel>> get caseListSink =>
      caseListController.sink;

  Stream<APIResponse<CaseTypeListModel>> get caseListStream =>
      caseListController.stream;

  MyCaseBloc() {
    myCaseRepository = MyCaseRepository();
    caseListController = StreamController<APIResponse<CaseTypeListModel>>();
  }

  getMyCasesList(Map<String, dynamic> params) async {
    caseListSink.add(APIResponse.loading('Loading...'));
    try {
      CaseTypeListModel caseList = await myCaseRepository.getCaseList(params);
      caseListSink.add(APIResponse.done(caseList));
    } catch (error) {
      caseListSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    caseListController.close();
  }
}