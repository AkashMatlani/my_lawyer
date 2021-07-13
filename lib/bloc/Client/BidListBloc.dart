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
      LawyerListModel bidList = await bidListRepository.getBidList(params);
      bidListSink.add(APIResponse.done(bidList));
    } catch (error) {
      bidListSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    bidListController.close();
  }
}
