import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:Artleap.ai/shared/app_persistance/app_local.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../presentation/views/login_and_signup_section/login_section/login_screen.dart';
import '../../shared/auth_exception_handler/auth_exception_handler.dart';
import '../../shared/console.dart';
import '../../shared/constants/hive_keys.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../shared/navigation/navigation.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Sign up
  Future<UserAuthResult> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(result.user);
      print("peeeeee");
      return UserAuthResult(userCredential: result);
    } on FirebaseAuthException catch (e) {
      console(e);
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String message = AuthExceptionHandler.generateExceptionMessage(status);
      // showSnackbar(message, bgColor: AppColors.red);
      console(';;;;;;;;;;;;;;;;;;;;;;;;;;');
      return UserAuthResult(
          authResultState: AuthResultStatus.error, message: message);
    }
  }

  // Sign in
  Future<UserAuthResult> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      AppLocal.ins.setUserData(HiveKeys.userId, result.user!.uid);
      return UserAuthResult(userCredential: result);
    } on FirebaseAuthException catch (e) {
      console(e);
      console(e);
      // String errormsg = e.toString();
      // String firebaseMsg = errormsg.substring(errormsg.indexOf(']') + 2);
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String message = AuthExceptionHandler.generateExceptionMessage(status);
      // showSnackbar(message, bgColor: AppColors.red);
      console(';;;;;;;;;;;;;;;;;;;;;;;;;;');
      return UserAuthResult(
          authResultState: AuthResultStatus.error, message: message);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
      appSnackBar(
          "Email has been sent",
          'Please check your email inbox and click on the link to  reset your password',
          AppColors.green);
      // return UserAuthResult(authType: AuthType.email, userCredential: user);
    } on FirebaseAuthException catch (e) {
      console(e);
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String message = AuthExceptionHandler.generateExceptionMessage(status);
      appSnackBar("Failed", message, AppColors.redColor);
      console(';;;;;;;;;;;;;;;;;;;;;;;;;;');
      // return null;
    }
  }

  Future<AuthResult?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: ["profile", "email"],
        // clientId: ,
        //  scopes: <String>[
        // 'email',
        //   'https://www.googleapis.com/auth/contacts.readonly',
        // ],
      ).signIn().catchError((error) {
        console(error);
        console('gooogle user cancelledddddddd');
        return null;
      });
      if (googleUser == null) {
        console('gooogle user nulllllllllllllllllll');
        return null;
      }
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      // return await FirebaseAuth.instance.signInWithCredential(credential);
      return AuthResult(
          userCredential:
              await FirebaseAuth.instance.signInWithCredential(credential));
    } catch (e) {
      console(e);
      console(';;;;;;;;;;;;;;;;;;;;;;;;;;');
      return null;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (error) {
      print("Apple Sign-In failed: $error");
      return null;
    }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = List.generate(
        length,
        (_) => charset[
            (DateTime.now().millisecondsSinceEpoch + _ * 31) % charset.length]);
    return random.join();
  }

  // Helper: Hash nonce with SHA256
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  // Future<AuthResult?> signInWithFacebook() async {
  //   try {
  //     final result = await FacebookAuth.i.login(
  //       permissions: [
  //         'email',
  //         'public_profile',
  //         // 'user_birthday',
  //         // 'user_friends',
  //         // 'user_gender',
  //         // 'user_link'
  //       ],
  //     );
  //     if (result.status == LoginStatus.success) {
  //       final userData = await FacebookAuth.i.getUserData(
  //           fields:
  //               "name,email,picture.width(200),birthday,friends,gender,link");
  //       final OAuthCredential credential =
  //           FacebookAuthProvider.credential(result.accessToken!.tokenString);

  //       // return await FirebaseAuth.instance.signInWithCredential(credential);
  //       return AuthResult(
  //           fbData: userData,
  //           userCredential:
  //               await FirebaseAuth.instance.signInWithCredential(credential));
  //     }
  //     console(result.message);
  //     console(';;;;;;;;;;;;;;;;;;;;;;;;;;');
  //     return null;
  //   } catch (e) {
  //     console(e);
  //     console(';;;;;;;;;;;;;;;;;;;;;;;;;;');
  //     return null;
  //   }
  // }
}

// enum AuthResultState { success, error, emailNotVerified }

class UserAuthResult {
  final UserCredential? userCredential;
  final AuthResultStatus authResultState;
  final String? message;
  UserAuthResult({
    this.userCredential,
    this.authResultState = AuthResultStatus.successful,
    this.message,
  });
}

class AuthResult {
  UserCredential? userCredential;
  final Map? fbData;
  AuthResult({this.userCredential, this.fbData});
}
