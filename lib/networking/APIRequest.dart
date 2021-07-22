import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APITag {
  static const signUp = 'signup';
  static const signIn = 'signin';
  static const forgotPwd = 'forgotpasswordapp';
  static const changePassword = 'changepassword';
  static const editprofile = 'editProfile';
  static const stateList = 'stateList';
  static const countyList = 'countyList';
  static const criminalList = 'criminalList';
  static const civilList = 'civilList';
  static const createCase = 'createCase';
  static const caseList = 'caseList';
  static const sendProposal = 'sendProposal';
  static const lawyerList = 'lawyerList';
  static const isLike = 'isLike';
  static const unLike = 'unLike';
  static const favLawyer = 'favLawyer';
  static const UnFavLawyer = 'unfavLawyer';
  static const acceptBid = 'acceptBid';
  static const lawyerDetail = 'lawyerDetail';
  static const viewBids = 'viewBids';
  static const caseDetail = 'caseDetail';
  static const registeredDeviceToken = 'registerDeviceToken';
  static const adList = 'adList';
  static const removeDeviceToken = 'removeDeviceToken';
  static const myCases = 'myCases';
  static const myBidding = 'myBids';
}

class CStatusCode {
  static const Status200 = 200;
  static const Status500 = 500;
}

class APIRequestHelper {
  final String baseURL = 'https://lawyer.xja.website/';

  Map<String, String> header = {
    'Accept': 'application/json',
    'Accept-Language': 'en'
  };

  Future<dynamic> get(String apiTag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('UserToken');

    // var headerAuth = header;
    // headerAuth['Authorization'] = '$token';
    var headerAuth = {'Authorization': token};

    print('============ Token: $token');
    var responseJson;
    try {
      var response;
      if (token != null) {
        response =
            await http.get(Uri.parse(baseURL + apiTag), headers: headerAuth);
      } else {
        response = await http.get(Uri.parse(baseURL + apiTag));
      }

      if (response.statusCode == CStatusCode.Status200) {
        responseJson = jsonDecode(response.body.toString());
        return responseJson;
      } else {
        return {
          'error': response.reasonPhrase,
          'statusCode': response.statusCode
        };
      }
    } on SocketException {
      throw Exception('Something is wrong');
    }
  }

  Future<dynamic> post(String apiTag, Map<String, dynamic> parameters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('UserToken');

    print('API $apiTag - $parameters');
    var headerAuth = {'Authorization': token};

    var responseJson;

    try {
      final response = await http.post(Uri.parse(baseURL + apiTag),
          body: parameters, headers: (token != null) ? headerAuth : header);
      if (response.statusCode == CStatusCode.Status200) {
        responseJson = jsonDecode(response.body.toString());
        return responseJson;
      } else {
        return {
          'error': response.reasonPhrase,
          'statusCode': response.statusCode
        };
      }
    } on SocketException {
      throw Exception('Something is wrong');
    }
  }

  Future<dynamic> postMultiFormData(
      String apiTag,
      Map<String, dynamic> parameters,
      List<dynamic> files,
      String fileParamName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('UserToken');
    var headerAuth = {'Authorization': token};

    var responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseURL + apiTag));

      if (files.length > 0) {
        if (files.length == 1) {
          if (files.first != '') {
            var multiPart =
                await http.MultipartFile.fromPath(fileParamName, files.first);
            request.files.add(multiPart);
          }
        } else {
          List<http.MultipartFile> multiPartFiles = [];

          for (String file in files) {
            var multiPart =
                await http.MultipartFile.fromPath(fileParamName, file);
            multiPartFiles.add(multiPart);
          }

          request.files.addAll(multiPartFiles);
        }
      }

      if (parameters != null) {
        request.fields.addAll(parameters);
      }

      request.headers.addAll((token != null) ? headerAuth : header);
      var response = await request.send();

      final responseToString = await response.stream.bytesToString();
      // responseJson = jsonDecode(responseToString);

      if (response.statusCode == CStatusCode.Status200) {
        responseJson = jsonDecode(responseToString);
        return responseJson;
      } else {
        return {
          'error': response.reasonPhrase,
          'statusCode': response.statusCode
        };
      }
    } on SocketException {
      throw Exception('Something is wrong');
    }
    return responseJson;
  }

  dynamic getResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body.toString());
      default:
        return Exception(response.body.toString());
    }
  }
}
