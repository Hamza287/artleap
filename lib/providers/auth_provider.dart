import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen.dart';
import 'package:photoroomapp/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:photoroomapp/shared/app_persistance/app_local.dart';
import '../domain/auth_services/auth_services.dart';
import '../presentation/views/onboarding_section/onboarding_screen.dart';
import '../shared/app_snack_bar.dart';
import '../shared/auth_exception_handler/auth_exception_handler.dart';
import '../shared/constants/app_colors.dart';
import '../shared/general_methods.dart';
import '../shared/navigation/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ObsecureText { loginPassword, signupPassword, confirmPassword }

enum LoginMethod { email, signup, google, facebook, apple, forgotPassword }

// Map<LoginMethod, bool> get loaders => _loaders;

final authprovider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

class AuthProvider extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _userNameController = TextEditingController();
  TextEditingController get userNameController => _userNameController;
  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  bool _loginPasswrdHideShow = true;
  bool get loginPasswrdHideShow => _loginPasswrdHideShow;
  bool _signupPasswrdHideShow = true;
  bool get signupPasswrdHideShow => _signupPasswrdHideShow;
  bool _confirmPasswrdHideShow = true;
  bool get confirmPasswrdHideShow => _confirmPasswrdHideShow;

  // A map to hold the loader state for each login method
  final Map<LoginMethod, bool> _loaders = {
    LoginMethod.email: false,
    LoginMethod.google: false,
    LoginMethod.facebook: false,
    LoginMethod.apple: false,
  };
  bool isLoading(LoginMethod loginMethod) {
    return _loaders[loginMethod] ?? false;
  }

  void startLoading(LoginMethod loginMethod) {
    _loaders[loginMethod] = true;
    notifyListeners();
  }

  // Method to stop loading for a specific login method
  void stopLoading(LoginMethod loginMethod) {
    _loaders[loginMethod] = false;
    notifyListeners();
  }

  // void setLoading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }
  UserAuthResult? authError;
  clearError() {
    authError = null;
    notifyListeners();
  }

  signUpWithEmail() async {
    // setLoading(true);

    if (userNameController.text.isEmpty || emailController.text.isEmpty) {
      authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: "Please fill all the fields");
      return;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: "Passwords are not matching");
    } else {
      startLoading(LoginMethod.signup);
      UserAuthResult? user = await _authServices.signUpWithEmail(
          _emailController.text, _passwordController.text);

      if (user.authResultState == AuthResultStatus.error) {
        authError = user;
        stopLoading(LoginMethod.signup);
      } else if (isNotNull(user)) {
        clearError();
        AppLocal.ins.setUserData(Hivekey.userName, _userNameController.text);

        appSnackBar("Success", "Sign up successful", AppColors.green);
        await firestore
            .collection('users')
            .doc(user.userCredential!.user!.uid)
            .set({
          'username': userNameController.text,
          'email': emailController.text,
        });
        clearControllers();
        Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
        stopLoading(LoginMethod.signup);
      }
    }
    notifyListeners();
  }

  signInWithEmail() async {
    startLoading(LoginMethod.email);

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      stopLoading(LoginMethod.email);
      authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: "Please fill all the fields");
      return;
    }
    UserAuthResult user = await _authServices.signInWithEmail(
        _emailController.text, _passwordController.text);
    stopLoading(LoginMethod.email);
    if (user.authResultState == AuthResultStatus.error) {
      authError = user;
    } else if (isNotNull(user)) {
      AppLocal.ins.setUserData(Hivekey.userId, user.userCredential!.user!.uid);
      AppLocal.ins.setUserData(
          Hivekey.userName, user.userCredential!.user!.displayName);
      AppLocal.ins
          .setUserData(Hivekey.userEmail, user.userCredential!.user!.email);
      appSnackBar("Success", "Sign in successful", AppColors.green);
      clearControllers();
      Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
      await firestore
          .collection('users')
          .doc(user.userCredential!.user!.uid)
          .set({
        'username': user.userCredential!.user!.displayName,
        'email': user.userCredential!.user!.email,
      });
    }
  }

  forgotPassword() async {
    startLoading(LoginMethod.forgotPassword);
    await _authServices.forgotPassword(emailController.text);
    stopLoading(LoginMethod.forgotPassword);
    notifyListeners();
  }

  signInWithGoogle() async {
    startLoading(LoginMethod.google);
    AuthResult? userCred = await _authServices.signInWithGoogle();

    if (isNotNull(userCred)) {
      appSnackBar("Success", "SignIn successfully!",
          const Color.fromARGB(255, 113, 235, 117));
      AppLocal.ins
          .setUserData(Hivekey.userId, userCred!.userCredential!.user!.uid);
      AppLocal.ins.setUserData(
          Hivekey.userName, userCred.userCredential!.user!.displayName);

      AppLocal.ins.setUserData(
          Hivekey.userProfielPic, userCred.userCredential!.user!.photoURL);
      AppLocal.ins
          .setUserData(Hivekey.userEmail, userCred.userCredential!.user!.email);
      Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
      await firestore
          .collection('users')
          .doc(userCred.userCredential!.user!.uid)
          .set({
        'id': userCred.userCredential!.user!.uid,
        'username': userCred.userCredential!.user!.displayName,
        'email': userCred.userCredential!.user!.email,
        'profile_image': userCred.userCredential!.user!.photoURL
      });
    }
    stopLoading(LoginMethod.google);
    notifyListeners();
  }

  signInWithFacebook() async {
    startLoading(LoginMethod.facebook);
    AuthResult? userCred = await _authServices.signInWithFacebook();

    if (isNotNull(userCred)) {
      appSnackBar("Success", "SignIn successfully!",
          const Color.fromARGB(255, 113, 235, 117));
      AppLocal.ins
          .setUserData(Hivekey.userId, userCred!.userCredential!.user!.uid);
      AppLocal.ins.setUserData(
          Hivekey.userName, userCred.userCredential!.user!.displayName);

      AppLocal.ins.setUserData(
          Hivekey.userProfielPic, userCred.userCredential!.user!.photoURL);
      Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
      await firestore
          .collection('users')
          .doc(userCred.userCredential!.user!.uid)
          .set({
        'id': userCred.userCredential!.user!.uid,
        'username': userCred.userCredential!.user!.displayName,
        'email': userCred.userCredential!.user!.email,
        'profile_image': userCred.userCredential!.user!.photoURL
      });
    }
    stopLoading(LoginMethod.facebook);
    notifyListeners();
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  obsecureTextFtn(ObsecureText field) {
    switch (field) {
      case ObsecureText.loginPassword:
        _loginPasswrdHideShow = !_loginPasswrdHideShow;
        break;
      case ObsecureText.signupPassword:
        _signupPasswrdHideShow = !_signupPasswrdHideShow;
        break;
      case ObsecureText.confirmPassword:
        _confirmPasswrdHideShow = !_confirmPasswrdHideShow;
        break;
    }
    notifyListeners();
  }
}
