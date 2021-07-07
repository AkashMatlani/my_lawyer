import 'package:my_lawyer/networking/APIRequest.dart';

class CreateCaseRepository {
  APIRequestHelper helper = APIRequestHelper();

  Future<dynamic> createCase(
      Map<String, dynamic> params, List<dynamic> files) async {
    var response = await helper.postMultiFormData(
        APITag.createCase, params, files, 'attachment[]');
    return response;
  }
}
