import 'package:Artleap.ai/domain/tutorial/tutorial_provider.dart';
import 'package:Artleap.ai/main/app_initialization.dart';
import 'package:Artleap.ai/presentation/views/common/privacy_policy_accept.dart';
import 'package:Artleap.ai/providers/splash_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../providers/user_profile_provider.dart';
import 'views/common/tutorial_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String routeName = "splash_screen";
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasNavigated = false;
  bool _initialized = false;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _startTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    if (_initialized) return;
    _initialized = true;

    final tutorialStorage = ref.read(tutorialStorageServiceProvider);
    await tutorialStorage.init();

    await ref.read(splashStateProvider.notifier).initializeApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashStateProvider);

    // Safe state listening
    ref.listen<SplashState>(splashStateProvider, (previous, current) {
      if (current == SplashState.readyToNavigate && !_hasNavigated) {
        _hasNavigated = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToNextScreen();
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.darkIndigo,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Lottie.asset(
            'assets/json/splashscreen.json',
            fit: BoxFit.cover,
            controller: _controller,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
          Center(
            child: Lottie.asset(
              'assets/json/logo.json',
              fit: BoxFit.cover,
            ),
          ),
          if (state == SplashState.noInternet ||
              state == SplashState.firebaseError)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    state == SplashState.noInternet
                        ? 'No internet connection'
                        : 'Service unavailable. Please try again',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _startTime = DateTime.now();
                      ref
                          .read(splashStateProvider.notifier)
                          .retryInitialization();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _navigateToNextScreen() async {
    final elapsedTime = DateTime.now().difference(_startTime!);
    final remainingTime = Duration(seconds: 4) - elapsedTime;

    if (remainingTime > Duration.zero) {
      await Future.delayed(remainingTime);
    }

    if (!mounted) return;

    final tutorialStorage = ref.read(tutorialStorageServiceProvider);
    final hasSeenTutorial = tutorialStorage.hasSeenTutorial();

    final userid = AppLocal.ins.getUSerData(Hivekey.userId) ?? "";
    final userName = AppLocal.ins.getUSerData(Hivekey.userName) ?? "";
    final userProfilePicture =
        AppLocal.ins.getUSerData(Hivekey.userProfielPic) ?? AppAssets.artstyle1;
    final userEmail = AppLocal.ins.getUSerData(Hivekey.userEmail) ?? "";

    // User is logged in
    if (userid.isNotEmpty) {
      UserData.ins.setUserData(
        id: userid,
        name: userName,
        userprofilePicture: userProfilePicture,
        email: userEmail,
      );

      await ref.read(userProfileProvider).getUserProfileData(userid);

      if (!mounted) return;

      final userProfile = ref.read(userProfileProvider).userProfileData;

      if (userProfile != null && userProfile.user.id.isNotEmpty) {
        await AppInitialization.registerUserDeviceTokenRef(ref);

        if (!hasSeenTutorial) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            TutorialScreen.routeName,
            (route) => false,
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            BottomNavBar.routeName,
            (route) => false,
          );

        }
      } else {
        if (!hasSeenTutorial) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            TutorialScreen.routeName,
            (route) => false,
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AcceptPrivacyPolicyScreen.routeName,
            (route) => false,
          );
        }
      }
    } else {
      if (!hasSeenTutorial) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          TutorialScreen.routeName,
          (route) => false,
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AcceptPrivacyPolicyScreen.routeName,
          (route) => false,
        );
      }
    }
  }
}
