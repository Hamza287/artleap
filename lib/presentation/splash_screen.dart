import 'package:Artleap.ai/presentation/views/common/privacy_policy_accept.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../providers/user_profile_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String routeName = "splash_screen";
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    String userid = AppLocal.ins.getUSerData(Hivekey.userId) ?? "";
    String userName = AppLocal.ins.getUSerData(Hivekey.userName) ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider).getUserProfileData(userid);
    });
    String userProfilePicture =
        AppLocal.ins.getUSerData(Hivekey.userProfielPic) ?? AppAssets.artstyle1;
    String userEmail = AppLocal.ins.getUSerData(Hivekey.userEmail) ?? "";
    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (userid.isNotEmpty) {
          UserData.ins.setUserData(
              id: userid,
              name: userName,
              userprofilePicture: userProfilePicture,
              email: userEmail);
          Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
        } else {
          Navigation.pushNamedAndRemoveUntil(AcceptPrivacyPolicyScreen.routeName);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkIndigo,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Lottie.asset(
            'assets/json/splashscreen.json',
            fit: BoxFit.cover,
          ),
          Center(
            child: Lottie.asset(
              'assets/json/logo.json',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
