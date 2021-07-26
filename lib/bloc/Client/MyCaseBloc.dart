import 'dart:async';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/MyCaseRepository.dart';
import 'package:my_lawyer/repository/Lawyer/CaseListRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

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
      var response = await myCaseRepository.getCaseList(params);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        caseListSink.add(APIResponse.error(response));
      } else {
        CaseTypeListModel modelResponse = CaseTypeListModel.fromJson(response);
        caseListSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      caseListSink.add(APIResponse.error({'message':error.toString()}));
    }
  }

  dispose() {
    caseListController.close();
  }
}
