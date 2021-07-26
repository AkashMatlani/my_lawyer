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
      var response = await adListRepository.getAdList();

      if ((response as Map<String, dynamic>).containsKey('statusCode')) {
        adListSink.add(APIResponse.error(response));
      } else {
        AdListModel modelResponse = AdListModel.fromJson(response);
        adListSink.add(APIResponse.done(modelResponse));
      }
    } catch (error) {
      adListSink.add(APIResponse.error({'message': error.toString()}));
    }
  }

  dispose() {
    adListController.close();
  }
}
