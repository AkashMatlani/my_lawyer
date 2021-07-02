import 'dart:async';
import 'package:my_lawyer/models/CaseListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/CivilRepository.dart';
import 'package:my_lawyer/repository/Client/CriminalRepository.dart';

class CivilBloc {
  CivilRepository civilRepository;
  StreamController civilController;

  StreamSink<APIResponse<CaseListModel>> get civilSink => civilController.sink;

  Stream<APIResponse<CaseListModel>> get civilStream => civilController.stream;

  CivilBloc() {
    civilRepository = CivilRepository();
    civilController = StreamController<APIResponse<CaseListModel>>();
  }

  getCivilList() async {
    civilSink.add(APIResponse.loading('Processing...'));
    try {
      CaseListModel caseList = await civilRepository.getCivilList();
      civilSink.add(APIResponse.done(caseList));
    } catch (error) {
      civilSink.add(APIResponse.error(error.toString()));
    }
  }
}
