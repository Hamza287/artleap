import 'package:Artleap.ai/shared/route_export.dart';

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
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2,
          disabledBackgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastStep ? "Get Started" : "Continue",
              style: AppTextstyle.interBold(
                fontSize: 16.0,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLastStep
                  ? Icon(Icons.rocket_launch, size: 16, color: theme.colorScheme.onPrimary)
                  : Icon(Icons.arrow_forward_ios_outlined, size: 16, color: theme.colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}