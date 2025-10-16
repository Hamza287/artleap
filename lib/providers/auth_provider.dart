import 'package:Artleap.ai/main/app_initialization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  final Map<LoginMethod, bool> _loaders = {
    LoginMethod.email: false,
    LoginMethod.google: false,
    LoginMethod.facebook: false,
    LoginMethod.apple: false,
    LoginMethod.signup: false,
    LoginMethod.forgotPassword: false,
  };
  bool isLoading(LoginMethod loginMethod) => _loaders[loginMethod] ?? false;

  void startLoading(LoginMethod loginMethod) {
    _loaders[loginMethod] = true;
    notifyListeners();
  }

  void stopLoading(LoginMethod loginMethod) {
    _loaders[loginMethod] = false;
    notifyListeners();
  }

  UserAuthResult? authError;
  void clearError() {
    authError = null;
    notifyListeners();
  }

  Future<void> storeFirebaseAuthToken({bool forceRefresh = false}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('No user signed in. Skipping token storage.');
        return;
      }
      final idToken = await user.getIdToken(forceRefresh);
      if (idToken != null) {
        AppData.instance.setToken(idToken);
      } else {
        debugPrint('Failed to obtain ID token.');
      }
    } catch (e) {
      debugPrint('Error storing Firebase token: $e');
      if (e is FirebaseAuthException) {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: AuthExceptionHandler.generateExceptionMessage(
              AuthExceptionHandler.handleException(e)),
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
      }
    }
  }

  Future<String?> ensureValidFirebaseToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('No user signed in. Skipping token refresh.');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigation.pushNamed(LoginScreen.routeName);
        });
        return null;
      }

      // 👇 Ensure user reloaded, then force a new ID token
      await user.reload();
      final idToken = await user.getIdToken(true); // forceRefresh = true
      if (idToken != null) {
        AppData.instance.setToken(idToken);
        debugPrint('✅ Firebase token refreshed (forced).');
        return idToken;
      } else {
        debugPrint('Failed to obtain ID token.');
        return null;
      }
    } catch (e) {
      debugPrint(
          'Error fetching Firebase token: $e (Code: ${e is FirebaseAuthException ? e.code : 'unknown'})');
      if (e is FirebaseAuthException) {
        final status = AuthExceptionHandler.handleException(e);
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: AuthExceptionHandler.generateExceptionMessage(status),
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
        if (status == AuthResultStatus.userNotFound ||
            status == AuthResultStatus.undefined ||
            e.code == 'invalid-user-token') {
          await FirebaseAuth.instance.signOut();
          AppData.instance.clearToken();
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
          });
        }
      } else {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: 'Failed to refresh token. Please try again.',
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
      }
      notifyListeners();
      return null;
    }
  }

  Future<void> signUpWithEmail() async {
    try {
      if (userNameController.text.isEmpty || emailController.text.isEmpty) {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: "Please fill all the fields",
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
        notifyListeners();
        return;
      } else if (_passwordController.text != _confirmPasswordController.text) {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: "Passwords are not matching",
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
        notifyListeners();
        return;
      }

      startLoading(LoginMethod.signup);
      UserAuthResult? user = await _authServices.signUpWithEmail(
        _emailController.text,
        _passwordController.text,
      );

      if (user.authResultState == AuthResultStatus.error) {
        authError = user;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
      } else if (isNotNull(user)) {
        clearError();
        await userSignup(
          userNameController.text,
          emailController.text,
          passwordController.text,
        );
        AppLocal.ins.setUserData(Hivekey.userName, _userNameController.text);
        AppLocal.ins.setUserData(Hivekey.userEmail, _emailController.text);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar("Success", "Sign up successful", AppColors.green);
          Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
        });
      }
    } catch (e) {
      debugPrint('Sign-up error: $e');
      authError = UserAuthResult(
        authResultState: AuthResultStatus.error,
        message: e is FirebaseAuthException
            ? AuthExceptionHandler.generateExceptionMessage(
                AuthExceptionHandler.handleException(e))
            : 'An unexpected error occurred during sign-up.',
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar('Error', authError!.message!, AppColors.red);
      });
    } finally {
      stopLoading(LoginMethod.signup);
      notifyListeners();
    }
  }

  Future<void> signInWithEmail() async {
    try {
      startLoading(LoginMethod.email);
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: "Please fill all the fields",
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
        stopLoading(LoginMethod.email);
        notifyListeners();
        return;
      }

      UserAuthResult user = await _authServices.signInWithEmail(
        _emailController.text,
        _passwordController.text,
      );

      if (user.authResultState == AuthResultStatus.error) {
        authError = user;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
      } else if (isNotNull(user)) {
        await userLogin(emailController.text, passwordController.text);
        await storeFirebaseAuthToken();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar("Success", "Sign in successful", AppColors.green);
        });
        clearControllers();
      }
    } catch (e) {
      debugPrint('Sign-in error: $e');
      authError = UserAuthResult(
        authResultState: AuthResultStatus.error,
        message: e is FirebaseAuthException
            ? AuthExceptionHandler.generateExceptionMessage(
                AuthExceptionHandler.handleException(e))
            : 'An unexpected error occurred during sign-in.',
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar('Error', authError!.message!, AppColors.red);
      });
    } finally {
      stopLoading(LoginMethod.email);
      notifyListeners();
    }
  }

  Future<void> forgotPassword() async {
    try {
      startLoading(LoginMethod.forgotPassword);
      if (emailController.text.isEmpty) {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: "Please enter your email address",
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
        notifyListeners();
        return;
      }

      await _authServices.forgotPassword(emailController.text);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar(
          'Success',
          'Password reset email sent. Check your inbox.',
          AppColors.green,
        );
      });
    } catch (e) {
      debugPrint('Forgot password error: $e');
      authError = UserAuthResult(
        authResultState: AuthResultStatus.error,
        message: e is FirebaseAuthException
            ? AuthExceptionHandler.generateExceptionMessage(
                AuthExceptionHandler.handleException(e))
            : 'Failed to send password reset email.',
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar('Error', authError!.message!, AppColors.red);
      });
    } finally {
      stopLoading(LoginMethod.forgotPassword);
      notifyListeners();
    }
  }

  // REPLACE your signInWithGoogle() body where noted
  Future<void> signInWithGoogle() async {
    try {
      startLoading(LoginMethod.google);

      AuthResult? userCred = await _authServices.signInWithGoogle();
      if (userCred != null &&
          userCred.userCredential != null &&
          userCred.userCredential!.user != null) {
        final user = userCred.userCredential!.user!;

        await user.reload();
        final token = await ensureValidFirebaseToken();
        if (token == null || token.isEmpty) {
          throw FirebaseAuthException(
              code: 'token-missing',
              message: 'Unable to fetch ID token after Google sign-in.');
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar("Success", "Sign in successful!",
              const Color.fromARGB(255, 113, 235, 117));
        });

        await googleLogin(
          user.displayName ?? 'User',
          user.email ?? '',
          user.uid,
          user.photoURL ?? '',
        );
      } else {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: 'Google sign-in failed. Please try again.',
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
      }
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      authError = UserAuthResult(
        authResultState: AuthResultStatus.error,
        message: e is FirebaseAuthException
            ? AuthExceptionHandler.generateExceptionMessage(
                AuthExceptionHandler.handleException(e))
            : 'An unexpected error occurred during Google sign-in.',
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar('Error', authError!.message!, AppColors.red);
      });
    } finally {
      stopLoading(LoginMethod.google);
      notifyListeners();
    }
  }

  Future<void> signInWithApple() async {
    try {
      startLoading(LoginMethod.apple);
      UserCredential? userCred = await _authServices.signInWithApple();
      if (isNotNull(userCred)) {
        final user = userCred!.user!;
        await storeFirebaseAuthToken();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar(
            "Success",
            "Sign in successful!",
            const Color.fromARGB(255, 113, 235, 117),
          );
        });
        await appleLogin(
          user.displayName ?? 'User',
          user.email ?? '',
          user.uid,
          user.photoURL ?? '',
        );
      } else {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: 'Apple sign-in failed. Please try again.',
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
      }
    } catch (e) {
      debugPrint('Apple sign-in error: $e');
      authError = UserAuthResult(
        authResultState: AuthResultStatus.error,
        message: e is FirebaseAuthException
            ? AuthExceptionHandler.generateExceptionMessage(
                AuthExceptionHandler.handleException(e))
            : 'An unexpected error occurred during Apple sign-in.',
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar('Error', authError!.message!, AppColors.red);
      });
    } finally {
      stopLoading(LoginMethod.apple);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      AppData.instance.clearToken();
      await AppLocal.ins.clearUserData();
      clearControllers();
      clearError();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
      });
    } catch (e) {
      debugPrint('Sign-out error: $e');
      authError = UserAuthResult(
        authResultState: AuthResultStatus.error,
        message: 'Failed to sign out. Please try again.',
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar('Error', authError!.message!, AppColors.red);
      });
    }
    notifyListeners();
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  void obsecureTextFtn(ObsecureText field) {
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

  Future<void> userLogin(String email, String password) async {
    try {
      Map<String, String> body = {
        "email": email,
        "password": password,
      };
      ApiResponse userRes = await authRepo.login(body: body);
      if (userRes.status == Status.completed) {
        reference.read(userProfileProvider).getUserProfileData(userRes.data["user"]['userId']);
        AppLocal.ins.setUserData(Hivekey.userId, userRes.data["user"]['userId']);
        AppLocal.ins.setUserData(Hivekey.userName, userRes.data["user"]['username']);

        await AppInitialization.registerUserDeviceToken(reference);

        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
        });
      } else {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: userRes.message ?? 'Failed to log in to backend.',
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
      }
    } catch (e) {
      debugPrint('Backend login error: $e');
      authError = UserAuthResult(
        authResultState: AuthResultStatus.error,
        message: 'Failed to connect to backend. Please try again.',
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar('Error', authError!.message!, AppColors.red);
      });
    }
    notifyListeners();
  }

  Future<void> userSignup(
      String userName, String email, String password) async {
    try {
      Map<String, String> body = {
        "username": userName,
        "email": email,
        "password": password,
      };
      ApiResponse userRes = await authRepo.signup(body: body);
      if (userRes.status != Status.completed) {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: userRes.message ?? 'Failed to sign up to backend.',
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
      }
    } catch (e) {
      debugPrint('Backend signup error: $e');
      authError = UserAuthResult(
        authResultState: AuthResultStatus.error,
        message: 'Failed to connect to backend. Please try again.',
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar('Error', authError!.message!, AppColors.red);
      });
    }
    notifyListeners();
  }

  Future<void> googleLogin(
      String userName, String email, String googleId, String profilePic) async {
    try {
      Map<String, String> body = {
        "username": userName,
        "email": email,
        "googleId": googleId,
        "profilePic": profilePic,
      };
      ApiResponse userRes = await authRepo.googleLogin(body: body);
      debugPrint("🔎 Google login raw response: ${userRes.data}");
      if (userRes.status == Status.completed) {
        final raw = userRes.data;
        final Map user = (raw is Map && raw['user'] is Map)
            ? raw['user'] as Map
            : (raw as Map);

        // Normalize keys & types
        final String userId =
            (user['userId'] ?? user['id'] ?? '').toString().trim();
        final String username = (user['username'] ?? userName).toString();
        final String userEmail = (user['email'] ?? email).toString();
        final String userPic =
            (user['profilePic'] ?? profilePic ?? '').toString();

        if (userId.isEmpty) {
          throw Exception('userId missing in backend response');
        }

        AppData.instance.setUserId(userId);
        reference.read(userProfileProvider).getUserProfileData(userId);

        AppLocal.ins.setUserData(Hivekey.userId, userId);
        AppLocal.ins.setUserData(Hivekey.userName, username);
        AppLocal.ins.setUserData(Hivekey.userEmail, userEmail);
        if (userPic.isNotEmpty) {
          AppLocal.ins.setUserData(Hivekey.userProfielPic, userPic);
        }

        await AppInitialization.registerUserDeviceToken(reference);

        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
        });
      } else {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: userRes.message ?? 'Failed to log in with Google.',
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
      }
    } catch (e) {
      debugPrint('Google backend login error: $e');
      authError = UserAuthResult(
        authResultState: AuthResultStatus.error,
        message: 'Failed to connect to backend. Please try again.',
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar('Error', authError!.message!, AppColors.red);
      });
    }
    notifyListeners();
  }

  Future<void> appleLogin(
      String userName, String email, String appleId, String profilePic) async {
    try {
      Map<String, String> body = {
        "username": userName,
        "email": email,
        "appleId": appleId,
        "profilePic": profilePic,
      };
      ApiResponse userRes = await authRepo.appleLogin(body: body);
      if (userRes.status == Status.completed) {
        reference
            .read(userProfileProvider)
            .getUserProfileData(userRes.data["user"]['userId']);
        AppLocal.ins
            .setUserData(Hivekey.userId, userRes.data["user"]['userId']);
        AppLocal.ins
            .setUserData(Hivekey.userName, userRes.data["user"]['username']);
        AppLocal.ins
            .setUserData(Hivekey.userEmail, userRes.data["user"]['email']);
        AppLocal.ins.setUserData(
            Hivekey.userProfielPic, userRes.data["user"]['profilePic']);

        await AppInitialization.registerUserDeviceToken(reference);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
        });
      } else {
        authError = UserAuthResult(
          authResultState: AuthResultStatus.error,
          message: userRes.message ?? 'Failed to log in with Apple.',
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          appSnackBar('Error', authError!.message!, AppColors.red);
        });
      }
    } catch (e) {
      debugPrint('Apple backend login error: $e');
      authError = UserAuthResult(
        authResultState: AuthResultStatus.error,
        message: 'Failed to connect to backend. Please try again.',
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        appSnackBar('Error', authError!.message!, AppColors.red);
      });
    }
    notifyListeners();
  }
}
