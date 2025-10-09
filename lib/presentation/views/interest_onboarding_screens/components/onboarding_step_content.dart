import 'package:Artleap.ai/providers/interest_onboarding_controller.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';

import 'contionus_button.dart';
import 'option_card.dart';

class OnboardingStepContent extends StatelessWidget {
  final OnboardingStepData stepData;
  final int currentStep;
  final int? selectedIndex;
  final Function(int) onOptionSelected;
  final VoidCallback onContinue;
  final bool isLastStep;

  const OnboardingStepContent({
    required this.stepData,
    required this.currentStep,
    required this.selectedIndex,
    required this.onOptionSelected,
    required this.onContinue,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;
    final safePadding = mediaQuery.padding;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepIndicator(currentStep + 1),
          const SizedBox(height: 20),
          Text(
            stepData.title,
            style: AppTextstyle.interBold(
              fontSize: isSmallScreen ? 24.0 : 28.0,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stepData.subtitle,
            style: AppTextstyle.interRegular(
              fontSize: isSmallScreen ? 16.0 : 18.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: stepData.options.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return OptionCard(
                  title: stepData.options[index],
                  isSelected: isSelected,
                  onTap: () => onOptionSelected(index),
                );
              },
            ),
          ),
          const SizedBox(height: 16.0),
          ContinueButton(
            isEnabled: selectedIndex != null,
            onPressed: onContinue,
            isLastStep: isLastStep,
          ),
          SizedBox(height: safePadding.bottom),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF875EFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF875EFF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: AppTextstyle.interBold(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Step $stepNumber',
            style: AppTextstyle.interMedium(
              fontSize: 14,
              color: const Color(0xFF875EFF),
            ),
          ),
        ],
      ),
    );
  }
}