import 'package:Artleap.ai/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ComingSoonButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? backgroundColor;

  const ComingSoonButton({
    super.key,
    required this.label,
    required this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Coming soon",
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: null,
          icon: Icon(icon, color: Colors.grey),
          label: Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.grey[50],
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: AppColors.purple.withOpacity(0.3),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}