import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<Map<String, dynamic>> appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final AuthCredential authCredential = OAuthProvider('apple.com')
          .credential(
              accessToken: credential.authorizationCode,
              idToken: credential.identityToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      if (userCredential != null) {
        print('Apple email - ${userCredential.user.email}');
        print('Apple familyName - ${credential.familyName}');
        print('Apple givenname - ${credential.givenName}');

        return {
          'name': '${credential.givenName} ${credential.familyName}',
          'email': userCredential.user.email
        };
      } else {
        print('Apple ======== - null');
      }

      // if (appleResult.error != null) {
      //   // handle errors from Apple here
      // }

      // final AuthCredential credential = OAuthProvider(providerId: 'apple.com').getCredential(
      //   accessToken: String.fromCharCodes(appleResult.credential.authorizationCode),
      //   idToken: String.fromCharCodes(appleResult.credential.identityToken),
      // );
      //
      // AuthResult firebaseResult = await _auth.signInWithCredential(credential);
      // FirebaseUser user = firebaseResult.user;
      //
      // // Optional, Update user data in Firestore
      // updateUserData(user);
      //
      // return user;
    } catch (error) {
      print('Apple Error - $error');
      return null;
    }
  }
}

// Future<AuthorizationCredentialAppleID> appleSignIn() async {
//
//   if (await SignInWithApple.isAvailable()) {
//     final credential = await SignInWithApple.getAppleIDCredential(
//       scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ],
//     );
//
//     if (credential != null) {
//       print('Apple email - ${credential.email}');
//       print('Apple givenName - ${credential.givenName}');
//       print('Apple familyName - ${credential.familyName}');
//
//       return credential;
//
//       // LoadingView().showLoaderWithTitle(true, context);
//       // signUpUser({
//       //   'userName': '${credential.givenName} ${credential.familyName}',
//       //   'email': credential.email,
//       //   'signInType': SignInType.Apple.toString()
//       // });
//     }
//   }
// }
// }
