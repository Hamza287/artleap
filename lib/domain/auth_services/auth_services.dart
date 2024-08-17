import 'package:firebase_auth/firebase_auth.dart';
import 'package:photoroomapp/shared/app_persistance/app_local.dart';

import '../../shared/console.dart';
import '../../shared/constants/hive_keys.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Sign up
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(result.user);
      print("peeeeee");
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      AppLocal.ins.setUserData(HiveKeys.userId, result.user!.uid);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AuthResult?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              // clientId: ,
              //  scopes: <String>[
              // 'email',
              //   'https://www.googleapis.com/auth/contacts.readonly',
              // ],
              )
          .signIn()
          .catchError((error) {
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
}

class AuthResult {
  UserCredential? userCredential;
  AuthResult({this.userCredential});
}
