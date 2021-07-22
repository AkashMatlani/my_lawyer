import 'dart:async';
import 'package:my_lawyer/models/BidListModel.dart';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/MyCaseRepository.dart';
import 'package:my_lawyer/repository/Lawyer/CaseListRepository.dart';
import 'package:my_lawyer/repository/Lawyer/MyBidRepository.dart';

class MyBidBloc {
  MyBidRepository myBidRepository;
  StreamController bidListController;

  StreamSink<APIResponse<BidListModel>> get caseListSink =>
      bidListController.sink;

  Stream<APIResponse<BidListModel>> get caseListStream =>
      bidListController.stream;

  MyBidBloc() {
    myBidRepository = MyBidRepository();
    bidListController = StreamController<APIResponse<BidListModel>>();
  }

  getMyBidList(Map<String, dynamic> params) async {
    caseListSink.add(APIResponse.loading('Loading...'));
    try {
      BidListModel caseList = await myBidRepository.getMyBidList(params);
      caseListSink.add(APIResponse.done(caseList));
    } catch (error) {
      caseListSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    bidListController.close();
  }
}
