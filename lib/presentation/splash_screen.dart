import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:photoroomapp/presentation/views/onboarding_section/onboarding_screen.dart';
import 'package:photoroomapp/shared/app_persistance/app_local.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/app_local_keys.dart';
import 'package:photoroomapp/shared/constants/user_data.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String routeName = "splash_screen";
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    var userid = AppLocal.ins.getUSerData(Hivekey.userId);
    var userName = AppLocal.ins.getUSerData(Hivekey.userName) ?? "";
    var userProfilePicture = AppLocal.ins.getUSerData(Hivekey.userProfielPic);
    var userEmail = AppLocal.ins.getUSerData(Hivekey.userEmail);
    _controller = VideoPlayerController.asset(AppAssets.splashscreen)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.setLooping(false);

    _controller.addListener(() {
      final isCompleted =
          _controller.value.position >= _controller.value.duration;
      if (isCompleted) {
        if (userid != null) {
          UserData.ins.setUserData(
              id: userid,
              name: userName,
              userprofilePicture: userProfilePicture ?? AppAssets.artstyle1,
              email: userEmail);
          Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName); 
        } else {
          Navigation.pushNamedAndRemoveUntil(OnboardingScreen.routeName);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    print("dispoooooooosoeeeeeeeedddd");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(
                        _controller,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child:
                  CircularProgressIndicator(), // Show a loading indicator until the video is initialized
            ),
    );
  }
}
