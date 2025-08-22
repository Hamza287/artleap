import 'package:Artleap.ai/presentation/views/personal_information/personal_info_screen.dart';
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
import '../../domain/subscriptions/subscription_model.dart';
import '../../presentation/views/Notifications/notification_details_screen.dart';
import '../../presentation/views/Notifications/notification_screen.dart';
import '../../presentation/views/about/about_artleap_screen.dart';
import '../../presentation/views/common/privacy_policy_accept.dart';
import '../../presentation/views/home_section/favourites_screen/favourites_screen.dart';
import '../../presentation/views/home_section/new_prompt_section/result/result_prompt_screen.dart';
import '../../presentation/views/home_section/profile_screen/policies_screens/help_screen.dart';
import '../../presentation/views/home_section/profile_screen/policies_screens/privacy_policy_screen.dart';
import '../../presentation/views/interest_onboarding_screens/interest_onboarding_screen.dart';
import '../../presentation/views/login_and_signup_section/login_section/login_screen.dart';
import '../../presentation/views/login_and_signup_section/signup_section/signup_screen.dart';
import '../../presentation/views/login_or_signup_screen/login_or_signup_screen.dart';
import '../../presentation/views/subscriptions/apple_payment_screen.dart';
import '../../presentation/views/subscriptions/choose_plan_screen.dart';
import '../../presentation/views/subscriptions/current_plan_screen.dart';
import '../../presentation/views/subscriptions/payment_screen.dart';


class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return route(const SplashScreen());
      case InterestOnboardingScreen.routeName:
        return route(const InterestOnboardingScreen());
      case AcceptPrivacyPolicyScreen.routeName:
        return route(const AcceptPrivacyPolicyScreen());
      case ChoosePlanScreen.routeName:
        return route(const ChoosePlanScreen());
      case PersonalInformationScreen.routeName:
        return route(const PersonalInformationScreen());
      case AboutArtleapScreen.routeName:
        return route(const AboutArtleapScreen());
      case LoginScreen.routeName:
        return route(const LoginScreen());
      case LoginORsignUpScreen.routeName:
        return route(const LoginORsignUpScreen());
      case SignUpScreen.routeName:
        return route(const SignUpScreen());
      case CurrentPlanScreen.routeName:
        return route(const CurrentPlanScreen());
      case FavouritesScreen.routeName:
        return route(const FavouritesScreen());
    // In your route_generator.dart
      case PaymentScreen.routeName:
        final args = settings.arguments as SubscriptionPlanModel;
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(plan: args),
          settings: settings,
        );

      case ApplePaymentScreen.routeName:
        final args = settings.arguments as SubscriptionPlanModel;
        return MaterialPageRoute(builder: (_) => ApplePaymentScreen(plan: args));

      case OnboardingScreen.routeName:
        return route(const OnboardingScreen());
      case BottomNavBar.routeName:
        return route(const BottomNavBar());
      case ResultScreenRedesign.routeName:
        return route(const ResultScreenRedesign());
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