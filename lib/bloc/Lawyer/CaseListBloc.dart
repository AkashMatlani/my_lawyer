import 'dart:async';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Lawyer/CaseListRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

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
    caseListSink.add(APIResponse.loading('Loading...'));
    try {
      var response = await caseListRepository.getCaseList(params);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        caseListSink.add(APIResponse.error(response));
      } else {
        CaseTypeListModel modelResponse = CaseTypeListModel.fromJson(response);
        caseListSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      caseListSink.add(APIResponse.error({CMessage:error.toString()}));
    }
  }

  dispose() {
    caseListController.close();
  }
}
