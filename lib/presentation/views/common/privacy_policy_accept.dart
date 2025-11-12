import 'package:Artleap.ai/domain/user_preferences/user_preferences_service.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/navigation/navigation.dart';
import '../../../shared/theme/custom_theme_extension.dart';
import '../interest_onboarding_screens/interest_onboarding_screen.dart';

final privacyPolicyLoadingProvider = StateProvider<bool>((ref) => false);

class AcceptPrivacyPolicyScreen extends ConsumerWidget {
  const AcceptPrivacyPolicyScreen({super.key});
  static const String routeName = "accept_privacy_policy";

  Future<void> _acceptPrivacyPolicy(WidgetRef ref, BuildContext context) async {
    final isLoading = ref.read(privacyPolicyLoadingProvider);
    if (isLoading) return;

    ref.read(privacyPolicyLoadingProvider.notifier).state = true;

    try {
      final userId = UserData.ins.userId;
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found');
      }

      final success = await ref.read(userPreferencesServiceProvider).acceptPrivacyPolicy(
        userId: userId,
        version: "1.0",
      );

      if (success) {
        if (context.mounted) {
          Navigation.pushNamedAndRemoveUntil(InterestOnboardingScreen.routeName);
        }
      } else {
        if (context.mounted) {
          appSnackBar('Error', 'Failed to accept privacy policy. Please try again.',backgroundColor: AppColors.red);
        }
      }
    } catch (e) {
      print(e);
      if (context.mounted) {
        appSnackBar('Error', 'An error occurred. Please try again.',backgroundColor: AppColors.red);
      }
    } finally {
      if (context.mounted) {
        ref.read(privacyPolicyLoadingProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>()!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final isLoading = ref.watch(privacyPolicyLoadingProvider);

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
                textAlign: TextAlign.left,
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
                  textAlign: TextAlign.left,
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
                textAlign: TextAlign.left,
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
                            Navigator.pushNamed(context, '/privacy-policy');
                          },
                      ),
                      TextSpan(text: ' and acknowledged I have read the '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/privacy-policy');
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: isLoading ? null : () => _acceptPrivacyPolicy(ref, context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: isLoading
                        ? LinearGradient(
                      colors: [Colors.grey.shade400, Colors.grey.shade600],
                    )
                        : customTheme.buttonGradient,
                    boxShadow: isLoading
                        ? []
                        : [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      'Accept and Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 15 : 17,
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