import 'dart:async';
import 'package:my_lawyer/models/BidListModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/BidListRepository.dart';

class BidListBloc {
  BidListRepository bidListRepository;
  StreamController bidListController;

  StreamSink<APIResponse<LawyerListModel>> get bidListSink =>
      bidListController.sink;

  Stream<APIResponse<LawyerListModel>> get bidListStream =>
      bidListController.stream;

  BidListBloc() {
    bidListRepository = BidListRepository();
    bidListController = StreamController<APIResponse<LawyerListModel>>();
  }

  getBidList(Map<String, dynamic> params) async {
    bidListSink.add(APIResponse.loading('Loading...'));
    try {
      var response = await bidListRepository.getBidList(params);

      if ((response as Map<String, dynamic>).containsKey('statusCode')) {
        bidListSink.add(APIResponse.error(response));
      } else {
        LawyerListModel modelResponse = LawyerListModel.fromJson(response);
        bidListSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      bidListSink.add(APIResponse.error({'message':error.toString()}));
    }
  }

  dispose() {
    bidListController.close();
  }
}
