import 'package:Artleap.ai/providers/interest_onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/constants/app_textstyle.dart';

class Step2 extends ConsumerWidget {
  const Step2({super.key});

  final List<String> roles = const [
    'Graphic Designer',
    'Photographer',
    'Video Editor',
    'Illustrator',
    'Animator'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final mediaQuery = MediaQuery.of(context);
      final screenWidth = mediaQuery.size.width;
      final isSmallScreen = screenWidth < 600;
      final safePadding = mediaQuery.padding;
      final selectedIndex = ref.watch(selectedRoleIndexProvider);

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16.0 : 24.0,
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's Get to Know You Better",
              style: AppTextstyle.interBold(
                fontSize: isSmallScreen ? 24.0 : 28.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Select the option that best describes your role. Voicify tailors its features to suit your needs",
              style: AppTextstyle.interRegular(
                fontSize: isSmallScreen ? 16.0 : 18.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: GestureDetector(
                      onTap: () => ref.read(selectedRoleIndexProvider.notifier).state = index,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF875EFF)
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              roles[index],
                              style: AppTextstyle.interMedium(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                color: Color(0xFF875EFF),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIndex == null
                    ? null
                    : () {
                  ref.read(interestOnboardingStepProvider.notifier).state++;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF875EFF),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Continue",
                    style: AppTextstyle.interBold(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Icon(Icons.arrow_forward_ios_outlined,size: 16,color: Colors.white,)
                ],
              ),
              ),
            ),
            SizedBox(height: safePadding.bottom),
          ],
        ),
      );
    } catch (e) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                "Something went wrong",
                style: AppTextstyle.interBold(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                e.toString(),
                style: AppTextstyle.interRegular(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(selectedRoleIndexProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF875EFF),
                ),
                child: Text(
                  "Retry",
                  style: AppTextstyle.interMedium(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}