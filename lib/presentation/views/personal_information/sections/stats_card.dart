import 'package:Artleap.ai/shared/route_export.dart';

class StatsCard extends StatelessWidget {
  final int followers;
  final int following;
  final int images;

  const StatsCard({
    super.key,
    required this.followers,
    required this.following,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              value: followers,
              label: "Followers",
              icon: Icons.people_alt_outlined,
              theme: theme,
            ),
            _StatItem(
              value: following,
              label: "Following",
              icon: Icons.person_outline,
              theme: theme,
            ),
            _StatItem(
              value: images,
              label: "Images",
              icon: Icons.image_outlined,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;
  final ThemeData theme;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: AppTextstyle.interBold(
            fontSize: 22,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextstyle.interRegular(
            fontSize: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}