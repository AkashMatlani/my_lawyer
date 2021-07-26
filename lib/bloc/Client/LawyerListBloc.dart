import 'dart:async';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/LawyerListRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

class LawyerListBloc {
  LawyerListRepository lawyerListRepository;
  StreamController lawyerListController;

  StreamSink<APIResponse<LawyerListModel>> get lawyerListSink =>
      lawyerListController.sink;

  Stream<APIResponse<LawyerListModel>> get lawyerListStream =>
      lawyerListController.stream;

  LawyerListBloc() {
    lawyerListRepository = LawyerListRepository();
    lawyerListController = StreamController<APIResponse<LawyerListModel>>();
  }

  getLawyerList(Map<String, dynamic> params) async {
    lawyerListSink.add(APIResponse.loading('Loading...'));
    try {
      var response = await lawyerListRepository.getLawyerList(params);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        lawyerListSink.add(APIResponse.error(response));
      } else {
        LawyerListModel modelResponse = LawyerListModel.fromJson(response);
        lawyerListSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      lawyerListSink.add(APIResponse.error({'message':error.toString()}));
    }
  }

  dispose() {
    lawyerListController.close();
  }
}
