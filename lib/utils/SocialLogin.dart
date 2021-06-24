import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class GoogleSignInClass {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  Future<GoogleSignInAccount> googleSignIn() async {
    bool isSignedIn = await _googleSignIn.isSignedIn();

    if (isSignedIn) {
      _googleSignIn.signOut();
    }

    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();

      if (account != null) {
        return account;
      }
    } catch (error) {
      print(error);
    }
  }
}

class AppleSignInClass {

  Future<AuthorizationCredentialAppleID> appleSignIn() async {
    if (await SignInWithApple.isAvailable()) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential != null) {
        return credential;

        // LoadingView().showLoaderWithTitle(true, context);
        // signUpUser({
        //   'userName': '${credential.givenName} ${credential.familyName}',
        //   'email': credential.email,
        //   'signInType': SignInType.Apple.toString()
        // });
      }
    }
  }
}
