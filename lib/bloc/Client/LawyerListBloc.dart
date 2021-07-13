import 'dart:async';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/LawyerListRepository.dart';

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
      LawyerListModel lawyerList =
          await lawyerListRepository.getLawyerList(params);
      lawyerListSink.add(APIResponse.done(lawyerList));
    } catch (error) {
      lawyerListSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    lawyerListController.close();
  }
}
