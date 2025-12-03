import 'dart:async';
import 'package:Artleap.ai/shared/theme/custom_theme_extension.dart';
import 'package:Artleap.ai/shared/route_export.dart';

final privacyPolicyLoadingProvider = StateProvider<bool>((ref) => false);
final adCompletionProvider = StateProvider<bool>((ref) => false);
final adDialogShownProvider = StateProvider<bool>((ref) => false);

class AcceptPrivacyPolicyScreen extends ConsumerStatefulWidget {
  const AcceptPrivacyPolicyScreen({super.key});
  static const String routeName = "accept_privacy_policy";

  @override
  ConsumerState<AcceptPrivacyPolicyScreen> createState() =>
      _AcceptPrivacyPolicyScreenState();
}

class _AcceptPrivacyPolicyScreenState
    extends ConsumerState<AcceptPrivacyPolicyScreen> {
  bool _navigationCompleted = false;
  bool _shouldShowAd = false;

  Future<void> _acceptPrivacyPolicy() async {
    final isLoading = ref.read(privacyPolicyLoadingProvider);
    if (isLoading) return;

    ref.read(privacyPolicyLoadingProvider.notifier).state = true;

    try {
      final userId = UserData.ins.userId;
      if (userId == null || userId.isEmpty) {
        throw Exception("User ID not found");
      }

      final success = await ref
          .read(userPreferencesServiceProvider)
          .acceptPrivacyPolicy(userId: userId, version: "1.0");

      if (!success) {
        if (mounted) {
          appSnackBar(
            'Error',
            'Failed to accept privacy policy. Please try again.',
            backgroundColor: AppColors.red,
          );
        }
        return;
      }

      final remoteConfig = RemoteConfigService.instance;

      if (remoteConfig.showNativeAds) {
        _shouldShowAd = true;

        final adNotifier = ref.read(nativeAdProvider.notifier);
        adNotifier.disposeAd();
        await adNotifier.loadNativeAd();
      } else {
        _navigateToInterestScreen();
      }
    } catch (e) {
      if (mounted) {
        appSnackBar(
          'Error',
          'An error occurred. Please try again.',
          backgroundColor: AppColors.red,
        );
      }
    } finally {
      if (mounted) {
        ref.read(privacyPolicyLoadingProvider.notifier).state = false;
      }
    }
  }

  void _navigateToInterestScreen() {
    if (_navigationCompleted) return;

    _navigationCompleted = true;

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigation.pushNamedAndRemoveUntil(
            InterestOnboardingScreen.routeName);
      });
    }
  }

  void _showAdDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) {
        return _AdDialogContent(
          onClose: _navigateToInterestScreen,
          onContinue: _navigateToInterestScreen,
        );
      },
    ).then((_) {
      if (!_navigationCompleted) {
        _navigateToInterestScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>()!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final isLoading = ref.watch(privacyPolicyLoadingProvider);

    // LISTEN TO NATIVE AD STATE HERE (correct Riverpod placement)
    ref.listen<NativeAdState>(nativeAdProvider, (prev, next) {
      if (!_navigationCompleted && next.isLoaded && _shouldShowAd) {
        _showAdDialog();
      }

      if (!_navigationCompleted &&
          next.errorMessage != null &&
          _shouldShowAd) {
        _navigateToInterestScreen();
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: customTheme.onboardingBackground,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20.0 : 24.0,
            vertical: screenHeight * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Text(
                'Ready to dive into a world of\nlimitless possibilities?',
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 22,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              SizedBox(height: screenHeight * 0.08),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return customTheme.headlineGradient.createShader(bounds);
                },
                child: Text(
                  'Take the leap,\nand we\'ll turn\nit into art!',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 38 : 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.13),
              Text(
                'With AI at your fingertips, every\nidea transforms into a stunning\nmasterpiece',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 15,
                  fontWeight: FontWeight.w500,
                  color: customTheme.secondaryText,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text.rich(
                  TextSpan(
                    text: 'I agree to the ',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 13,
                      color: customTheme.secondaryText,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms of use',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                                context, '/privacy-policy');
                          },
                      ),
                      const TextSpan(
                          text: ' and acknowledged I have read the '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                                context, '/privacy-policy');
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: isLoading ? null : _acceptPrivacyPolicy,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: isLoading
                        ? LinearGradient(
                      colors: [
                        Colors.grey.shade400,
                        Colors.grey.shade600
                      ],
                    )
                        : customTheme.buttonGradient,
                    boxShadow: isLoading
                        ? []
                        : [
                      BoxShadow(
                        color: theme.colorScheme.primary
                            .withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      'Accept and Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                        isSmallScreen ? 15 : 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdDialogContent extends ConsumerWidget {
  final VoidCallback onClose;
  final VoidCallback onContinue;

  const _AdDialogContent({
    required this.onClose,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adState = ref.watch(nativeAdProvider);

    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  'Advertisement',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                    Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 330,
              child: adState.isLoaded && adState.nativeAd != null
                  ? AdWidget(ad: adState.nativeAd!)
                  : const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onContinue,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Continue to App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
