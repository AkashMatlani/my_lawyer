import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_lawyer/networking/APIRequest.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/SocialLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';

logOut() {
  removeDeviceToken();

  SharedPreferences.getInstance().then((preference) {
    preference.remove(UserPrefernces.UserInfo);
    preference.remove(UserPrefernces.UserToken);
  });

  GoogleSignIn _googleSignIn = GoogleSignIn();
  _googleSignIn.isSignedIn().then((isSignedIn) {
    if (isSignedIn) _googleSignIn.signOut();
  });

  FirebaseAuth.instance.signOut();
}

dynamic getUserInfo() async {
  SharedPreferences.getInstance().then((prefs) {
    var userInfoStr = prefs.getString(UserPrefernces.UserInfo);
    var userInfo = json.decode(userInfoStr);
    return userInfo;
  });
}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

String getFileNameFromURL(String url) {
  File file = new File(url);
  return file.path.split('/').last;
}

Future<dynamic> registeredDeviceToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString(UserPrefernces.FCMToken);

  APIRequestHelper helper = APIRequestHelper();
  var response =
      await helper.post(APITag.registeredDeviceToken, {'token': token});
  print('Response - $response');
  return response;
}

removeDeviceToken() async {
  APIRequestHelper helper = APIRequestHelper();
  var response = await helper.get(APITag.removeDeviceToken);

  if (response['meta']['status'] == 1) {
    SharedPreferences.getInstance().then((preference) {
      preference.remove(UserPrefernces.FCMToken);
    });
  }
}
