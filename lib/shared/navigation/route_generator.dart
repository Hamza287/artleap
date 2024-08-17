import 'package:flutter/material.dart';
import 'package:photoroomapp/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:photoroomapp/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:photoroomapp/presentation/views/onboarding_section/onboarding_screen.dart';
import 'package:photoroomapp/shared/navigation/screen_params.dart';

import '../../presentation/views/login_and_signup_section/login_section/login_screen.dart';
import '../../presentation/views/login_and_signup_section/signup_section/signup_screen.dart';
import '../../presentation/views/login_or_signup_screen/login_or_signup_screen.dart';

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routeName:
        return route(const LoginScreen(
            // params: settings.arguments as HomeScreenArgs?
            ));
      case LoginORsignUpScreen.routeName:
        return route(const LoginORsignUpScreen());
      case SignUpScreen.routeName:
        return route(const SignUpScreen());
      case OnboardingScreen.routeName:
        return route(const OnboardingScreen());
      case BottomNavBar.routeName:
        return route(BottomNavBar(
          title: "adfasfs",
        ));
      case SeePictureScreen.routeName:
        return route(
            SeePictureScreen(params: settings.arguments as SeePictureParams?));
      // case FirstScreen.routeName:
      //   return route(FirstScreen(
      //       firstScreenArgs: settings.arguments as FirstScreenArgs));
      default:
        return route(const ErrorRoute());
    }
  }
}

Route route(Widget screen) => MaterialPageRoute(builder: (context) => screen);

class ErrorRoute extends StatelessWidget {
  const ErrorRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('You should not be here...')));
}
