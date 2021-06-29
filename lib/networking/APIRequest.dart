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
      // final response = await http.get(Uri.parse(baseURL + apiTag), headers: (getToken() != null) ? headerAuth : {}));
      responseJson = getResponse(response);
    } on SocketException {
      throw Exception('Something is wrong');
    }

    return responseJson;
  }

  Future<dynamic> post(String apiTag, Map<String, dynamic> parameters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('UserToken');

    print('API $apiTag - $parameters');
    // var headerAuth = header;
    // headerAuth['Authorization'] = '$token';
    var headerAuth = {'Authorization': token};

    var responseJson;
    try {
      final response = await http.post(Uri.parse(baseURL + apiTag),
          body: parameters,
          headers: (token != null)
              ? headerAuth
              : header); //, headers: (token != null) ? headerAuth : header
      responseJson = jsonDecode(response.body.toString());
    } on SocketException {
      throw Exception('Something is wrong');
    }

    return responseJson;
  }

  Future<dynamic> postMultiFormData(
      String apiTag, Map<String, dynamic> parameters, String file) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('UserToken');

// var headerAuth = header;
    // headerAuth['Authorization'] = '$token';
    var headerAuth = {'Authorization': token};

    var responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseURL + apiTag));

      if (file != "") {
        var multiPart = await http.MultipartFile.fromPath('userProfile', file);
        request.files.add(multiPart);
      }

      if (parameters != null) {
        request.fields.addAll(parameters);
      }

      request.headers.addAll((token != null) ? headerAuth : header);
      var response = await request.send();
      final responseToString = await response.stream.bytesToString();
      responseJson = jsonDecode(responseToString);
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
