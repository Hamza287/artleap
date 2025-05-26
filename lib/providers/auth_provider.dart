import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/base_repo/base_repo.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/presentation/views/home_section/home_screen/home_screen.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/app_persistance/app_local.dart';
import '../domain/api_services/api_response.dart';
import '../domain/auth_services/auth_services.dart';
import '../shared/app_snack_bar.dart';
import '../shared/auth_exception_handler/auth_exception_handler.dart';
import '../shared/constants/app_colors.dart';
import '../shared/general_methods.dart';
import '../shared/navigation/navigation.dart';

enum ObsecureText { loginPassword, signupPassword, confirmPassword }

enum LoginMethod { email, signup, google, facebook, apple, forgotPassword }

// Map<LoginMethod, bool> get loaders => _loaders;

final authprovider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref));

class AuthProvider extends ChangeNotifier with BaseRepo {
  final AuthServices _authServices = AuthServices();
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
  final Ref reference;
  AuthProvider(this.reference);
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
        userSignup(userNameController.text, emailController.text,
            passwordController.text);
        AppLocal.ins.setUserData(Hivekey.userName, _userNameController.text);
        AppLocal.ins.setUserData(Hivekey.userEmail, _emailController.text);
        appSnackBar("Success", "Sign up successful", AppColors.green);
        print(userNameController.text);
        print("sssssssssssssssssssss");
        print(userNameController.text);
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
      userLogin(emailController.text, passwordController.text);

      appSnackBar("Success", "Sign in successful", AppColors.green);
      clearControllers();
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

      print("lllllllllllllllllllllllllllllllllllll");

      print(userCred!.userCredential!.user!.uid);
      print(userCred.userCredential!.user!.displayName);
      googleLogin(
          userCred.userCredential!.user!.displayName!,
          userCred.userCredential!.user!.email!,
          userCred.userCredential!.user!.uid,
          userCred.userCredential!.user!.photoURL!);
    }
    stopLoading(LoginMethod.google);
    notifyListeners();
  }

  // signInWithFacebook() async {
  //   startLoading(LoginMethod.facebook);
  //   AuthResult? userCred = await _authServices.signInWithFacebook();

  //   if (isNotNull(userCred)) {
  //     appSnackBar("Success", "SignIn successfully!",
  //         const Color.fromARGB(255, 113, 235, 117));
  //     AppLocal.ins
  //         .setUserData(Hivekey.userId, userCred!.userCredential!.user!.uid);
  //     AppLocal.ins.setUserData(
  //         Hivekey.userName, userCred.userCredential!.user!.displayName);

  //     AppLocal.ins.setUserData(
  //         Hivekey.userProfielPic, userCred.userCredential!.user!.photoURL);
  //     Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
  //     await firestore
  //         .collection('users')
  //         .doc(userCred.userCredential!.user!.uid)
  //         .set({
  //       'id': userCred.userCredential!.user!.uid,
  //       'username': userCred.userCredential!.user!.displayName,
  //       'email': userCred.userCredential!.user!.email,
  //       'profile_image': userCred.userCredential!.user!.photoURL
  //     });
  //   }
  //   stopLoading(LoginMethod.facebook);
  //   notifyListeners();
  // }

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

  userLogin(String email, String password) async {
    print("entryyyyyyyyyyyyyy");
    Map<String, String> body = {
      "email": email,
      "password": password,
    };
    print(body);
    ApiResponse userRes = await authRepo.login(body: body);
    print(userRes.data);
    if (userRes.status == Status.completed) {
      reference
          .read(userProfileProvider)
          .getUserProfileData(userRes.data["user"]['userId']);
      AppLocal.ins.setUserData(Hivekey.userId, userRes.data["user"]['userId']);
      AppLocal.ins
          .setUserData(Hivekey.userName, userRes.data["user"]['username']);
      Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
    }
    print(userRes.data);
    print(userRes.message);
    print(userRes.status);
    print("lllllllllllllllllll");
  }

  userSignup(String userName, String email, String password) async {
    print("entryyyyyyyyyyyyyy");
    Map<String, String> body = {
      "username": userName,
      "email": email,
      "password": password,
    };
    print(body);
    print("kkkkkkkkkkkkkkkkkkk");
    ApiResponse userRes = await authRepo.signup(body: body);
    print(userRes.data);
    print(userRes.message);
    print(userRes.status);
    print("lllllllllllllllllll");
  }

  googleLogin(
      String userName, String email, String googleId, String profilePic) async {
    print("entryyyyyyyyyyyyyy");
    Map<String, String> body = {
      "username": userName,
      "email": email,
      "googleId": googleId,
      "profilePic": profilePic
    };
    print(body);
    ApiResponse userRes = await authRepo.googleLogin(body: body);
    if (userRes.status == Status.completed) {
      reference
          .read(userProfileProvider)
          .getUserProfileData(userRes.data["user"]['userId']);
      print(userRes);
      print(userRes.data);
      print(userRes.data["user"]['userId']);
      print(userRes.data["user"]['username']);
      print(userRes.data["user"]['email']);
      AppLocal.ins.setUserData(Hivekey.userId, userRes.data["user"]['userId']);
      AppLocal.ins
          .setUserData(Hivekey.userName, userRes.data["user"]['username']);
      AppLocal.ins
          .setUserData(Hivekey.userEmail, userRes.data["user"]['email']);
      AppLocal.ins.setUserData(
          Hivekey.userProfielPic, userRes.data["user"]['profilePic']);
    }
    Future.delayed(const Duration(seconds: 1), () {
      Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
    });
    print(userRes.data);
    print(userRes.message);
    print(userRes.status);
    print("lllllllllllllllllll");
  }
}
