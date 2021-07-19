import 'package:my_lawyer/models/StateModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';
import 'package:my_lawyer/utils/DatabaseHelper.dart';

class StateRepository {
  APIRequestHelper helper = APIRequestHelper();
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<void> stateList() async {
    var response = await helper.get(APITag.stateList);

    if (response['data'] != null) {
      List<dynamic> data = response['data'];
      for (dynamic state in data) {
        var result = databaseHelper
            .insertStateData(StateModel(int.parse(state['id']), state['name']));

        if (result != 0) {}
      }

      var list = databaseHelper.getStateList().then((value) {
        print('State Count - ${value.length}');
      });
    }
  }

  getStateList() {
    databaseHelper.getStateList().then((value) {
      print('State Count - ${value.length}');
      if (value.length == 0) stateList();
    });
  }
}
