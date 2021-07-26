import 'dart:async';
import 'package:my_lawyer/models/CaseListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/CivilRepository.dart';
import 'package:my_lawyer/repository/Client/CriminalRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

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
    civilSink.add(APIResponse.loading('Loading...'));
    try {
      var response = await civilRepository.getCivilList();

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        civilSink.add(APIResponse.error(response));
      } else {
        CaseListModel modelResponse = CaseListModel.fromJson(response);
        civilSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      civilSink.add(APIResponse.error({CMessage:error.toString()}));
    }
  }

  dispose() {
    civilController.close();
  }
}
