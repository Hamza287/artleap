import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;
  final bool isLastStep;

  const ContinueButton({
    required this.isEnabled,
    required this.onPressed,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF875EFF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2,
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastStep ? "Get Started" : "Continue",
              style: AppTextstyle.interBold(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLastStep
                  ? const Icon(Icons.rocket_launch, size: 16, color: Colors.white)
                  : const Icon(Icons.arrow_forward_ios_outlined, size: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}