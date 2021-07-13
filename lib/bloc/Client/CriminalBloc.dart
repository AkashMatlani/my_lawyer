import 'dart:async';
import 'package:my_lawyer/models/CaseListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/CriminalRepository.dart';

class CriminalBloc {

  CriminalRepository criminalRepository;
  StreamController criminalController;

  StreamSink<APIResponse<CaseListModel>> get criminalSink =>
      criminalController.sink;

  Stream<APIResponse<CaseListModel>> get criminalStream =>
      criminalController.stream;

  CriminalBloc() {
    criminalRepository = CriminalRepository();
    criminalController = StreamController<APIResponse<CaseListModel>>();
  }

  getCriminalList() async {
    criminalSink.add(APIResponse.loading('Loading...'));
    try {
      CaseListModel caseList = await criminalRepository.getCriminalList();
      criminalSink.add(APIResponse.done(caseList));
    } catch (error){
      criminalSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    criminalController.close();
  }
}