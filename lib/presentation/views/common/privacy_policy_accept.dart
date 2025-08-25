import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../shared/navigation/navigation.dart';
import '../interest_onboarding_screens/interest_onboarding_screen.dart';

class AcceptPrivacyPolicyScreen extends StatefulWidget {
  const AcceptPrivacyPolicyScreen({super.key});
  static const String routeName = "accept_privacy_policy";

  @override
  State<AcceptPrivacyPolicyScreen> createState() => _AcceptPrivacyPolicyScreenState();
}

class _AcceptPrivacyPolicyScreenState extends State<AcceptPrivacyPolicyScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.2,
              colors: [
                Color(0xFFB499FF),
                Colors.white,
              ],
            ),
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
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: screenHeight * 0.08),

              // Gradient headline
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Color(0xFF9B5CFF), Color(0xFF7E4EFF)],
                  ).createShader(bounds);
                },
                child: Text(
                  'Take the leap,\nand we\'ll turn\nit into art!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 38 : 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Required for ShaderMask
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
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),

              // Legal text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text.rich(
                  TextSpan(
                    text: 'I agree to the ',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 13,
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms of use',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.pushNamed(context, '/privacy-policy');
                        },
                      ),
                      const TextSpan(text: ' and acknowledged I have read the '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.pushNamed(context, '/privacy-policy');
                        },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              // Button with gradient background
              GestureDetector(
                onTap: (){
                  Navigation.pushNamedAndRemoveUntil(InterestOnboardingScreen.routeName);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD765FF), Color(0xFF6D40DA)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  ),
                  child: Center(
                    child: Text(
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
