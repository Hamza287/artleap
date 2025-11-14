import 'package:Artleap.ai/shared/route_export.dart';

class AccountActionsCard extends StatelessWidget {
  const AccountActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Icon(Icons.account_circle_outlined, color: AppColors.purple),
                  const SizedBox(width: 12),
                  Text(
                    "Account",
                    style: AppTextstyle.interBold(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            _ActionTile(
              icon: Icons.settings_outlined,
              label: "Settings",
              onTap: null,
            ),
            const Divider(height: 1, indent: 20),
            _ActionTile(
              icon: Icons.help_outline,
              label: "Help & Support",
              onTap: null,
            ),
            const Divider(height: 1, indent: 20),
            _ActionTile(
              icon: Icons.privacy_tip_outlined,
              label: "Privacy Policy",
              onTap: null,
            ),
            const Divider(height: 1, indent: 20),
            _ActionTile(
              icon: Icons.logout,
              label: "Logout",
              color: Colors.red,
              onTap: () {
                // TODO: Implement logout
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(
        icon,
        color: color ?? Colors.grey[700],
      ),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.grey[800],
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: color ?? Colors.grey[500],
      ),
      onTap: onTap,
    );
  }
}