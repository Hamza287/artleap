import 'package:Artleap.ai/shared/route_export.dart';

class ResultHeader extends ConsumerWidget {
  const ResultHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              ref.read(generateImageProvider).clearGeneratedData();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: theme.colorScheme.onSurface,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Creation',
                style: AppTextstyle.interMedium(
                  fontSize: 24,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'AI Generated Art',
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'New',
            style: AppTextstyle.interMedium(
              fontSize: 12,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}