import 'dart:async';
import 'package:my_lawyer/models/BidListModel.dart';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/MyCaseRepository.dart';
import 'package:my_lawyer/repository/Lawyer/CaseListRepository.dart';
import 'package:my_lawyer/repository/Lawyer/MyBidRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

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
      var response = await myBidRepository.getMyBidList(params);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        caseListSink.add(APIResponse.error(response));
      } else {
        BidListModel modelResponse = BidListModel.fromJson(response);
        caseListSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      caseListSink.add(APIResponse.error({'message':error.toString()}));
    }
  }

  dispose() {
    bidListController.close();
  }
}
