import 'dart:async';
import 'package:my_lawyer/models/CaseListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/CriminalRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

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
      var response = await criminalRepository.getCriminalList();

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        criminalSink.add(APIResponse.error(response));
      } else {
        CaseListModel modelResponse = CaseListModel.fromJson(response);
        criminalSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      criminalSink.add(APIResponse.error({CMessage:error.toString()}));
    }
  }

  dispose() {
    criminalController.close();
  }
}
