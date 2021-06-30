import 'package:my_lawyer/models/CountyModel.dart';
import 'package:my_lawyer/networking/APIRequest.dart';
import 'package:my_lawyer/utils/DatabaseHelper.dart';

class CountyRepository {
  APIRequestHelper helper = APIRequestHelper();
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<dynamic> countyList() async {
    var response = await helper.get(APITag.countyList);

    if (response['data'] != null) {
      List<dynamic> data = response['data'];
      for (dynamic county in data) {
        var result = databaseHelper.insertCountyData(CountyModel(
            int.parse(county['countyId']),
            county['name'],
            int.parse(county['stateId'])));

        if (result != 0) {
          print('County Added ========');
        }
      }

      var list = databaseHelper.getCountyList(37).then((value) {
        print('County Count - ${value.length}');
      });
    }

    // if (response['data'] != null) {
    //   List<dynamic> data = response['data'];
    //   data.map((countyInfo) {
    //     var result = databaseHelper.insertCountyData(CountyModel(
    //         int.parse(countyInfo['stateId']), int.parse(countyInfo['countyId']), countyInfo['name']));
    //
    //     if (result != 0) {
    //       print('County Added ========');
    //
    //       var list = databaseHelper.getCountyList(37).then((value) {
    //         print('County Count - ${value.length}');
    //       });
    //     }
    //   });
    // }
  }
}
