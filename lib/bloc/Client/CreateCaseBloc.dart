import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/CreateCaseRepository.dart';
import 'package:my_lawyer/utils/Constant.dart';

class CreateCaseBloc {
  CreateCaseRepository createCaseRepository;
  StreamController createCaseController;

  StreamSink<APIResponse<dynamic>> get createCaseSink =>
      createCaseController.sink;

  Stream<APIResponse<dynamic>> get createCaseStream =>
      createCaseController.stream;

  CreateCaseBloc() {
    createCaseRepository = CreateCaseRepository();
    createCaseController = StreamController<APIResponse<dynamic>>();
  }

  createCase(Map<String, dynamic> params, List<dynamic> files) async {
    createCaseSink.add(APIResponse.loading('Loading...'));
    try {
      dynamic response = await createCaseRepository.createCase(params, files);

      if ((response as Map<String, dynamic>).containsKey(StatusCode)) {
        createCaseSink.add(APIResponse.error(response));
      } else {
        createCaseSink.add(APIResponse.done(response));
      }
    } catch (error) {
      createCaseSink.add(APIResponse.error({'message': error.toString()}));
    }
  }

  dispose() {
    createCaseController.close();
  }
}
