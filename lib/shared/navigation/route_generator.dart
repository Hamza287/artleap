import 'package:flutter/material.dart';
import 'package:Artleap.ai/domain/notification_model/notification_model.dart';
import 'package:Artleap.ai/presentation/splash_screen.dart';
import 'package:Artleap.ai/presentation/views/forgot_password_section/forgot_password_screen.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/edit_profile_screen.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/other_user_profile_screen.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/full_image_viewer_screen.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/presentation/views/onboarding_section/onboarding_screen.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import '../../presentation/views/Notifications/notification_details_screen.dart';
import '../../presentation/views/Notifications/notification_screen.dart';
import '../../presentation/views/home_section/profile_screen/policies_screens/help_screen.dart';
import '../../presentation/views/home_section/profile_screen/policies_screens/privacy_policy_screen.dart';
import '../../presentation/views/login_and_signup_section/login_section/login_screen.dart';
import '../../presentation/views/login_and_signup_section/signup_section/signup_screen.dart';
import '../../presentation/views/login_or_signup_screen/login_or_signup_screen.dart';

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return route(const SplashScreen());
      case LoginScreen.routeName:
        return route(const LoginScreen());
      case LoginORsignUpScreen.routeName:
        return route(const LoginORsignUpScreen());
      case SignUpScreen.routeName:
        return route(const SignUpScreen());
      case OnboardingScreen.routeName:
        return route(const OnboardingScreen());
      case BottomNavBar.routeName:
        return route(const BottomNavBar());
      case SeePictureScreen.routeName:
        return route(
            SeePictureScreen(params: settings.arguments as SeePictureParams?));
      case EditProfileScreen.routeName:
        return route(EditProfileScreen(
          params: settings.arguments as EditProfileSreenParams?,
        ));
      case OtherUserProfileScreen.routeName:
        return route(OtherUserProfileScreen(
          params: settings.arguments as OtherUserProfileParams?,
        ));
      case ForgotPasswordScreen.routeName:
        return route(const ForgotPasswordScreen());
      case FullImageViewerScreen.routeName:
        return route(
          FullImageViewerScreen(
            params: settings.arguments as FullImageScreenParams,
          ),
        );
      case PrivacyPolicyScreen.routeName:
        return route(const PrivacyPolicyScreen());
      case HelpScreen.routeName:
        return route(const HelpScreen());
      case NotificationScreen.routeName:
        return route(const NotificationScreen());
      case NotificationDetailScreen.routeName:
        final args = settings.arguments as AppNotification;
        return route(NotificationDetailScreen(notification: args));
      default:
        return route(const ErrorRoute());
    }
  }

  static Route route(Widget screen) => MaterialPageRoute(builder: (context) => screen);
}

class ErrorRoute extends StatelessWidget {
  const ErrorRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('You should not be here...')));
}