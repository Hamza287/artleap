import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/base_repo/base_repo.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/app_persistance/app_local.dart';
import '../domain/api_services/api_response.dart';
import '../domain/auth_services/auth_services.dart';
import '../shared/app_persistance/app_data.dart';
import '../shared/app_snack_bar.dart';
import '../shared/auth_exception_handler/auth_exception_handler.dart';
import '../shared/constants/app_colors.dart';
import '../shared/general_methods.dart';
import '../shared/navigation/navigation.dart';

enum ObsecureText { loginPassword, signupPassword, confirmPassword }

enum LoginMethod { email, signup, google, facebook, apple, forgotPassword }

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

  bool _loginPasswordHideShow = true;
  bool get loginPasswordHideShow => _loginPasswordHideShow;
  bool _signupPasswordHideShow = true;
  bool get signupPasswordHideShow => _signupPasswordHideShow;
  bool _confirmPasswordHideShow = true;
  bool get confirmPasswordHideShow => _confirmPasswordHideShow;
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

  UserAuthResult? authError;
  clearError() {
    authError = null;
    notifyListeners();
  }

  Future<void> storeFirebaseAuthToken({bool forceRefresh = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idToken = await user.getIdToken(forceRefresh);
      AppData.instance.setToken(idToken!);
    }
  }

  Future<void> ensureValidFirebaseToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idToken = await user.getIdToken(true); // true = force refresh
      AppData.instance.setToken(idToken!);
    }
  }



  signUpWithEmail() async {
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
      await storeFirebaseAuthToken();
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
    if (userCred != null && userCred.userCredential != null && userCred.userCredential!.user != null) {
      final user = userCred.userCredential!.user!;
      await storeFirebaseAuthToken();
      appSnackBar("Success", "SignIn successfully!",
          const Color.fromARGB(255, 113, 235, 117));

      await googleLogin(
          user.displayName ?? 'User',
          user.email ?? '',
          user.uid,
          user.photoURL ?? '');
    }
    stopLoading(LoginMethod.google);
    notifyListeners();
  }

  signInWithApple() async {
    startLoading(LoginMethod.apple);
    UserCredential? userCred = await _authServices.signInWithApple();
    if (isNotNull(userCred)) {
      await storeFirebaseAuthToken();
      appSnackBar("Success", "SignIn successfully!",
          const Color.fromARGB(255, 113, 235, 117));

      print(userCred!.user!.uid);
      print(userCred.user!);
      appleLogin(userCred.user!.displayName!, userCred.user!.email!,
          userCred.user!.uid, userCred.user!.photoURL!);
    }
    stopLoading(LoginMethod.apple);
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
        _loginPasswordHideShow = !_loginPasswordHideShow;
        break;
      case ObsecureText.signupPassword:
        _signupPasswordHideShow = !_signupPasswordHideShow;
        break;
      case ObsecureText.confirmPassword:
        _confirmPasswordHideShow = !_confirmPasswordHideShow;
        break;
    }
    notifyListeners();
  }

  userLogin(String email, String password) async {
    Map<String, String> body = {
      "email": email,
      "password": password,
    };
    ApiResponse userRes = await authRepo.login(body: body);
    if (userRes.status == Status.completed) {
      reference
          .read(userProfileProvider)
          .getUserProfileData(userRes.data["user"]['userId']);
      AppLocal.ins.setUserData(Hivekey.userId, userRes.data["user"]['userId']);
      AppLocal.ins
          .setUserData(Hivekey.userName, userRes.data["user"]['username']);
      Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
    }
  }

  userSignup(String userName, String email, String password) async {
    Map<String, String> body = {
      "username": userName,
      "email": email,
      "password": password,
    };
    await authRepo.signup(body: body);
  }

  googleLogin(
      String userName, String email, String googleId, String profilePic) async {
    Map<String, String> body = {
      "username": userName,
      "email": email,
      "googleId": googleId,
      "profilePic": profilePic
    };
    ApiResponse userRes = await authRepo.googleLogin(body: body);
    if (userRes.status == Status.completed) {
      reference
          .read(userProfileProvider)
          .getUserProfileData(userRes.data["user"]['userId']);
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
  }

  appleLogin(
      String userName, String email, String appleId, String profilePic) async {
    Map<String, String> body = {
      "username": userName,
      "email": email,
      "appleId": appleId,
      "profilePic": profilePic
    };
    ApiResponse userRes = await authRepo.appleLogin(body: body);
    if (userRes.status == Status.completed) {
      reference
          .read(userProfileProvider)
          .getUserProfileData(userRes.data["user"]['userId']);
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
  }
}
