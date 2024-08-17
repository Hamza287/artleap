import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:photoroomapp/shared/navigation/navigator_key.dart';

import '../domain/auth_services/auth_services.dart';
import '../presentation/views/onboarding_section/onboarding_screen.dart';
import '../shared/app_persistance/app_local.dart';
import '../shared/app_snack_bar.dart';
import '../shared/constants/app_colors.dart';
import '../shared/constants/hive_keys.dart';
import '../shared/general_methods.dart';
import '../shared/navigation/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ObsecureText { loginPassword, signupPassword, confirmPassword }

final authprovider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

class AuthProvider extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final HiveKeys _hiveKeys = HiveKeys();
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _loginPasswrdHideShow = true;
  bool get loginPasswrdHideShow => _loginPasswrdHideShow;

  bool _signupPasswrdHideShow = true;
  bool get signupPasswrdHideShow => _signupPasswrdHideShow;

  bool _confirmPasswrdHideShow = true;
  bool get confirmPasswrdHideShow => _confirmPasswrdHideShow;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signUpWithEmail() async {
    if (userNameController.text.isEmpty || emailController.text.isEmpty) {
      appSnackBar("Please fill the form. Thank you!", AppColors.redColor);
      return;
    } else if (passwordController.text != confirmPasswordController.text) {
      appSnackBar(
          "Confirm Password does not match password", AppColors.redColor);
      return;
    }

    setLoading(true);
    try {
      User? user = await _authServices.signUpWithEmail(
          _emailController.text, _passwordController.text);
      setLoading(false);
      if (user != null) {
        appSnackBar("Sign up successful", AppColors.green);
        await firestore.collection('users').doc(user.uid).set({
          'username': userNameController.text,
          'email': emailController.text,
        });
        clearControllers();
        Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
      } else {
        appSnackBar("Sign up failed", AppColors.redColor);
      }
    } catch (e) {
      setLoading(false);
      appSnackBar(e.toString(), AppColors.redColor);
    }
  }

  Future<void> signInWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      appSnackBar("Please fill the form. Thank you!", AppColors.redColor);
      return;
    }
    setLoading(true);
    try {
      User? user = await _authServices.signInWithEmail(
          _emailController.text, _passwordController.text);
      setLoading(false);
      if (user != null) {
        appSnackBar("Sign in successful", AppColors.green);
        clearControllers();

        Navigation.pushNamedAndRemoveUntil(OnboardingScreen.routeName);
      } else {
        appSnackBar("Sign in failed", AppColors.redColor);
      }
    } catch (e) {
      setLoading(false);
      appSnackBar(e.toString(), AppColors.redColor);
    }
  }

  signInWithGoogle() async {
    setLoading(true);
    AuthResult? userCred = await _authServices.signInWithGoogle();
    if (isNotNull(userCred)) {
      appSnackBar("SignIn successfully!", AppColors.green);
      Navigation.pushNamedAndRemoveUntil(OnboardingScreen.routeName);
      await firestore
          .collection('users')
          .doc(userCred!.userCredential!.user!.uid)
          .set({
        'username': userCred.userCredential!.user!.displayName,
        'email': userCred.userCredential!.user!.email,
      });
    }
    setLoading(false);
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
