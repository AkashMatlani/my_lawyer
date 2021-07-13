import 'dart:async';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/repository/Client/CreateCaseRepository.dart';

class CreateCaseBloc {

  CreateCaseRepository createCaseRepository;
  StreamController createCaseController;

  StreamSink<APIResponse<dynamic>> get createCaseSink =>
      createCaseController.sink;

  Stream<APIResponse<dynamic>> get createCaseStream =>
      createCaseController.stream;


  CreateCaseBloc() {
    createCaseRepository = CreateCaseRepository();
    createCaseController = StreamController<APIResponse<dynamic>>.broadcast();
  }

  createCase(Map<String, dynamic> params, List<dynamic> files) async {
    createCaseSink.add(APIResponse.loading('Loading...'));
    try {
      dynamic response = await createCaseRepository.createCase(params, files);
      createCaseSink.add(APIResponse.done(response));
    } catch (error) {
      createCaseSink.add(APIResponse.error(error.toString()));
    }
  }

  dispose() {
    createCaseController.close();
  }
}