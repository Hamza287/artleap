import 'package:Artleap.ai/shared/route_export.dart';


class CancelPurchaseButton extends StatelessWidget {
  final VoidCallback onCancel;

  const CancelPurchaseButton({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: onCancel,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cancel_rounded,
              size: 18,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(
              'Cancel Purchase',
              style: AppTextstyle.interMedium(
                fontSize: 14,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}