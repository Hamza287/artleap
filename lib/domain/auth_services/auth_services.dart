import 'dart:convert';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Artleap.ai/shared/app_persistance/app_local.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../shared/auth_exception_handler/auth_exception_handler.dart';
import '../../shared/constants/hive_keys.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../shared/navigation/navigation.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ["profile", "email"],
  );

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print("Error signing out from Google: $e");
    }
  }

  Future<UserAuthResult> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return UserAuthResult(userCredential: result);
    } on FirebaseAuthException catch (e) {
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String message = AuthExceptionHandler.generateExceptionMessage(status);
      return UserAuthResult(
          authResultState: AuthResultStatus.error, message: message);
    }
  }

  Future<UserAuthResult> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      AppLocal.ins.setUserData(HiveKeys.userId, result.user!.uid);
      return UserAuthResult(userCredential: result);
    } on FirebaseAuthException catch (e) {
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String message = AuthExceptionHandler.generateExceptionMessage(status);
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
          'Please check your email inbox and click on the link to reset your password',
          AppColors.green);
    } on FirebaseAuthException catch (e) {
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String message = AuthExceptionHandler.generateExceptionMessage(status);
      appSnackBar("Failed", message, AppColors.redColor);
    }
  }

  Future<AuthResult?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'google-signin-cancelled',
          message: 'Google sign-in was cancelled by user.',
        );
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
        throw FirebaseAuthException(
          code: 'google-auth-failed',
          message: 'Failed to get authentication tokens from Google.',
        );
      }

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'Failed to create user with Google credentials.',
        );
      }

      return AuthResult(userCredential: userCredential);
    } on FirebaseAuthException catch (e) {
      print(e);
      rethrow;
    } catch (e) {
      print(e);
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred during Google sign-in: $e',
      );
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

      if (appleCredential.identityToken == null) {
        throw FirebaseAuthException(
          code: 'apple-auth-failed',
          message: 'Failed to get identity token from Apple.',
        );
      }

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'Failed to create user with Apple credentials.',
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (error) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred during Apple sign-in: $error',
      );
    }
  }

  String generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = List.generate(
        length,
            (_) => charset[(DateTime.now().millisecondsSinceEpoch + _ * 31) % charset.length]);
    return random.join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

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