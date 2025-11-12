import 'package:flutter_riverpod/flutter_riverpod.dart';

final interestOnboardingStepProvider = StateProvider<int>((ref) => 0);

final onboardingDataProvider = StateProvider<List<OnboardingStepData>>((ref) => [
  OnboardingStepData(
    title: "Let's Get to Know You Better",
    subtitle: "Select the option that best describes your role. Voicify tailors its features to suit your needs",
    options: [
      'Freelancer',
      'Content Creator',
      'Teacher & Instructor',
      'Social Media Specialist',
      'Student'
    ],
  ),
  OnboardingStepData(
    title: "What's Your Creative Field?",
    subtitle: "Choose the creative domain that matches your interests and skills",
    options: [
      'Graphic Designer',
      'Photographer',
      'Video Editor',
      'Illustrator',
      'Animator'
    ],
  ),
  OnboardingStepData(
    title: "Your Artistic Interests",
    subtitle: "Select the artistic activities that inspire you the most",
    options: [
      'Painter',
      'Writer',
      'Musician',
      'Crafter',
      'Dancer'
    ],
  ),
  OnboardingStepData(
    title: "Technical & Digital Skills",
    subtitle: "Pick the digital skills that align with your professional goals",
    options: [
      'Web Developer',
      'UI/UX Designer',
      'Digital Marketer',
      'Game Developer',
      'Data Analyst'
    ],
  ),
]);

final selectedOptionsProvider = StateProvider<List<int?>>((ref) => [null, null, null, null]);

class OnboardingStepData {
  final String title;
  final String subtitle;
  final List<String> options;

  OnboardingStepData({
    required this.title,
    required this.subtitle,
    required this.options,
  });
}