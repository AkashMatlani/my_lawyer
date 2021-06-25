import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/SocialLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

logOut() {
  SharedPreferences.getInstance().then((preference) {
    preference.remove(UserPrefernces.UserInfo);
    preference.remove(UserPrefernces.UserToken);
  });

  GoogleSignIn _googleSignIn = GoogleSignIn();
  _googleSignIn.isSignedIn().then((isSignedIn) {
    if (isSignedIn) _googleSignIn.signOut();
  });
}
