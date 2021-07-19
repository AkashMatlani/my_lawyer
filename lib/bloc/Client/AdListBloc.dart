import 'dart:async';
import 'package:my_lawyer/models/AdModel.dart';
import 'package:my_lawyer/models/BidListModel.dart';
import 'package:my_lawyer/models/LawyerListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/AdListRepository.dart';
import 'package:my_lawyer/repository/Client/BidListRepository.dart';

class AdListBloc {
  AdListRepository adListRepository;
  StreamController adListController;

  StreamSink<APIResponse<AdListModel>> get adListSink => adListController.sink;

  Stream<APIResponse<AdListModel>> get adListStream => adListController.stream;

  AdListBloc() {
    adListRepository = AdListRepository();
    adListController = StreamController<APIResponse<AdListModel>>();
  }

  getAdList() async {
    adListSink.add(APIResponse.loading('Loading...'));
    try {
      AdListModel adList = await adListRepository.getAdList();
      adListSink.add(APIResponse.done(adList));
    } catch (error) {
      adListSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    adListController.close();
  }
}
